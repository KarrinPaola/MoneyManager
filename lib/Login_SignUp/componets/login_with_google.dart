import 'package:back_up/Overview/my_over_view.dart';
import 'package:back_up/userID_Store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_database_for_new_user.dart';

Future<void> loginWithGG(BuildContext context) async {
  // Hiển thị hộp thoại tải lên
  showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });

  try {
    // Bắt đầu quá trình đăng nhập bằng Google
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      // Người dùng đã hủy đăng nhập
      Navigator.pop(context); // Đóng hộp thoại tải lên
      return;
    }

    // Lấy thông tin xác thực từ Google
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // Tạo thông tin xác thực cho Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Đăng nhập vào Firebase
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Lấy userId và email của người dùng
    String userId = userCredential.user!.uid;
    UserStorage.userId = userId;
    print(UserStorage.userId);
    String userEmail = userCredential.user!.email ?? '';

    // Kiểm tra xem người dùng đã tồn tại trong Firestore chưa
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      // Nếu người dùng chưa tồn tại, tạo cơ sở dữ liệu cho người dùng
      await createUserDatabase(userId, userEmail);
    }

    // Đóng hộp thoại tải lên
    Navigator.pop(context);

    // Điều hướng đến màn hình chính
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyOverview()),
    );
  } on FirebaseAuthException catch (e) {
    print('Google Login Error: ${e.message}');

    // Đóng hộp thoại tải lên
    Navigator.pop(context);

    // Hiển thị thông báo lỗi
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng nhập thất bại'),
          content: Text(e.message ?? 'An error occurred.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại lỗi
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Unexpected Error: $e');

    // Đóng hộp thoại tải lên
    Navigator.pop(context);

    // Hiển thị thông báo lỗi chung
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng nhập thất bại'),
          content: const Text('Có lỗi xảy ra. Vui lòng thử lại sau.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại lỗi
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
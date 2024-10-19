import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_page.dart';
import 'create_database_for_new_user.dart';

Future<void> registerUser({
  required BuildContext context,
  required TextEditingController usernameController,
  required TextEditingController passwordController,
  required TextEditingController reenterPasswordController,
}) async {
  // Kiểm tra mật khẩu nhập lại có khớp hay không
  if (passwordController.text != reenterPasswordController.text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register Failed'),
          content: const Text('Passwords do not match.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  // Kiểm tra email đã đăng ký hay chưa
  try {
    List<String> signInMethods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(usernameController.text.trim());

    if (signInMethods.isNotEmpty) {
      // Nếu email đã đăng ký, hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Register Failed'),
            content: const Text('Email was used. Please use another Email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng hộp thoại
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
  } catch (e) {
    print('Error checking email existence: $e');
    return;
  }

  // Hiển thị hộp thoại tải lên
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    // Đăng ký Firebase
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Đăng ký thành công
    String userId = userCredential.user!.uid;

    // Tạo cơ sở dữ liệu cho người dùng mới
    await createUserDatabase(userId, usernameController.text);

    // Xóa các TextField
    usernameController.clear();
    passwordController.clear();
    reenterPasswordController.clear();

    // Đóng hộp thoại tải lên
    Navigator.pop(context);

    // Hiển thị hộp thoại đăng ký thành công
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register Successfully'),
          content: const Text('Your account is created'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại thành công
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Điều hướng về trang đăng nhập
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } on FirebaseAuthException catch (e) {
    print('Register Error: ${e.message}');

    // Đóng hộp thoại tải lên
    Navigator.pop(context);

    // Hiển thị hộp thoại lỗi
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register Failed'),
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
  }
}
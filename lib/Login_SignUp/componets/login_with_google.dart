import 'package:back_up/Overview/my_over_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_database_for_new_user.dart';


Future<void> loginWithGG(BuildContext context) async {
  // Bắt đầu quá trình đăng nhập bằng Google
  final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  // Kiểm tra xem người dùng có đăng nhập thành công không
  if (gUser == null) {
    // Người dùng đã hủy đăng nhập
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

  // Lấy userId (uid) của người dùng
  String userId = userCredential.user!.uid;
  String userEmail = userCredential.user!.uid;

  // Kiểm tra xem người dùng đã tồn tại trong Firestore chưa
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (!userDoc.exists) {
    // Nếu người dùng chưa tồn tại, tạo cơ sở dữ liệu cho người dùng
    await createUserDatabase(userId, userEmail);
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyOverview()),
  );
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'create_database_for_new_user.dart';

class RegisterByEmail {
  // Hàm đăng ký người dùng
  Future<void> registerUser({
    required BuildContext context,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required TextEditingController reenterPasswordController,
  }) async {
    // Check if passwords match
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
                  Navigator.pop(context); // Đóng thông báo
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Kiểm tra xem email đã được đăng ký chưa
    try {
      List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(usernameController.text.trim());

      if (signInMethods.isNotEmpty) {
        // Nếu email đã được đăng ký, hiển thị thông báo lỗi
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Register Failed'),
              content: const Text('Email was used. Please use another Email.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng thông báo
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

    // Hiển thị loading dialog
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Firebase registration
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Đăng ký thành công
      String userId = userCredential.user!.uid;

      // Tạo cơ sở dữ liệu cho người dùng mới
      await createUserDatabase(userId, usernameController.text);

      // Xóa dữ liệu trong các TextFields
      usernameController.clear();
      passwordController.clear();
      reenterPasswordController.clear();

      // Đóng loading dialog
      Navigator.pop(context);

      // Hiển thị thông báo thành công
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Register Successfully'),
            content: const Text('Your account is created'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng thông báo
                  Navigator.pop(context); // Quay về trang login
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print('Register Error: ${e.message}');

      // Đóng loading dialog
      Navigator.pop(context);

      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Register Failed'),
            content: Text(e.message ?? 'Have errors, please try again!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng thông báo
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Login_SignUp/componets/my_button.dart';
import '../../Login_SignUp/componets/my_textField.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Text editing controllers
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool stateChangePassword = true;

  // Function to change password
  void changePassword() async {
    // Hiển thị hộp thoại tải lên
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) {
        Navigator.pop(context); // Đóng hộp thoại tải lên
        _showError('Người dùng không tìm thấy');
        return;
      }

      // Đăng nhập lại người dùng với mật khẩu cũ
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text.trim(),
        ),
      );

      // Kiểm tra mật khẩu mới và mật khẩu xác nhận
      final newPassword = newPasswordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        Navigator.pop(context);
        _showError('Mật khẩu xác nhận không khớp');
        return;
      }

      if (newPassword.length < 6) {
        Navigator.pop(context);
        _showError('Mật khẩu mới phải có ít nhất 6 ký tự');
        return;
      }

      // Thay đổi mật khẩu
      await user.updatePassword(newPassword);

      // Cập nhật trạng thái thành công
      Navigator.pop(context); // Đóng hộp thoại tải lên
      _showSuccess('Đổi mật khẩu thành công');
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Đóng hộp thoại tải lên
      _showError(e.message ?? 'Lỗi khi thay đổi mật khẩu');
    }
  }

  // Function to show success message
  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to show error message
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Đổi mật khẩu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!stateChangePassword)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFD8D7),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Color(0xFFB00020)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Đổi mật khẩu thất bại",
                        style: TextStyle(color: Color(0xFFB00020)),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            MyTextField(
              controller: oldPasswordController,
              hintText: 'Mật khẩu cũ',
              obscureText: true,
              prefixIcon: Icons.password,
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: newPasswordController,
              hintText: 'Mật khẩu mới',
              obscureText: true,
              prefixIcon: Icons.password,
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Xác nhận mật khẩu',
              obscureText: true,
              prefixIcon: Icons.password,
            ),
            const SizedBox(height: 20),
            MyButton(
              onTap: changePassword,
              text: "ĐỔI MẬT KHẨU",
            ),
          ],
        ),
      ),
    );
  }
}

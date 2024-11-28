import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _handleChangePassword() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      _showMessage('Mật khẩu mới phải có ít nhất 6 ký tự');
    } else if (newPassword != confirmPassword) {
      _showMessage('Mật khẩu xác nhận không khớp');
    } else {
      _showMessage('Đổi mật khẩu thành công');
      // Thêm logic đổi mật khẩu tại đây
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi mật khẩu'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Color(0xFFedeff1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(labelText: 'Mật khẩu cũ'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: 'Mật khẩu mới'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2144FA),
                foregroundColor: Colors.white,
              ),
              child: Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}

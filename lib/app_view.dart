import 'package:flutter/material.dart';

import 'Login_SignUp/login_page.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface:  Color(0x0fffffff), // Màu nền chính
          onSurface: Color(0xFFedeff1), // Màu nền phụ
          primary:  Color(0xFF1e42f9), // Màu xanh dương chủ đạo cho các nút
          secondary:  Color(0xFF000000), // Màu đen cho chữ chính
          tertiary:  Color(0xFF9ba1a8), // Màu xám cho chữ phụ
          outline: Color(0xFFedeff1), // Màu viền và các yếu tố phân cách
        ),
      ),
      home: const LoginPage(),
    );
  }
}

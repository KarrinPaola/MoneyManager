import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Login_SignUp/login_page.dart';
import '../../check_login.dart';
import '../../userID_Store.dart';
import 'change_password_page.dart';
import 'about_page.dart';

class OverviewSetReminder extends StatelessWidget {
  const OverviewSetReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFedeff1),
        appBar: AppBar(
          title: const Text(
            'Cài đặt',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.lock, color: Colors.black),
                title: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 18, ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: const Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 18, ),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  UserStorage.userId = "";
                  isLogined = false;

                  // Navigate back to the login page after signing out
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ),
            // Thêm logo ở đây
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.asset(
                    'lib/Login_SignUp/Images/logoApp.png',
                    height: 100, // Chiều cao của logo
                    width: 100, // Chiều rộng của logo
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.info, color: Colors.black),
                    title: const Text(
                      'Giới thiệu',
                      style:
                          TextStyle(fontSize: 18,),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

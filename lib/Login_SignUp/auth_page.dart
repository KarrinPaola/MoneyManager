import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Overview/myOverView.dart';
import 'login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MyOverview();
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}

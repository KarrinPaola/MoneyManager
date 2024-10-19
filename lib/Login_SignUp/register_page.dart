

import 'package:flutter/material.dart';

import 'componets/login_with.dart';
import 'componets/login_with_google.dart';
import 'componets/my_button.dart';
import 'componets/my_textField.dart';
import 'componets/register_by_email.dart';
import 'componets/textGesture.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.ontap});
  final Function()? ontap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final reenterPasswordController = TextEditingController();

  bool stateRegister = true;

  // Register user method

  void forgotPassword() {}

  void goToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('lib/Login_SignUp/Images/logoApp.png'),
              ),
              const Text(
                "monex",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (!stateRegister) // Conditionally render error message
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
                          "Passwords do not match or registration error",
                          style: TextStyle(color: Color(0xFFB00020)),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              MyTextField(
                controller: usernameController,
                hintText: 'Email',
                obscureText: false,
                prefixIcon: Icons.person_2,
                statusLogin: stateRegister,
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                prefixIcon: Icons.password,
                statusLogin: stateRegister,
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: reenterPasswordController,
                hintText: 'Re-enter Password',
                obscureText: true,
                prefixIcon: Icons.password,
                statusLogin: stateRegister,
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                onTap: () {
                  registerUser(
                      context: context,
                      usernameController: usernameController,
                      passwordController: passwordController,
                      reenterPasswordController: reenterPasswordController);
                },
                text: "REGISTER",
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                child: const Center(
                  child: Text(
                    'Or',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const LoginWith(
                onTap: loginWithGG,
                imagePath: 'lib/Login_SignUp/Images/google.png',
                brand: 'GOOGLE',
              ),
              const SizedBox(
                height: 15,
              ),
              const LoginWith(
                onTap: loginWithGG,
                imagePath: 'lib/Login_SignUp/Images/apple-logo.png',
                brand: 'APPLE',
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You have an account?",
                    style: TextStyle(fontSize: 15, color: Color(0xFF000000)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Textgesture(
                    text: 'Login now',
                    ontap: goToLogin,
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}

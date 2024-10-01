import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'componets/forgotPasswordButtom.dart';
import 'componets/login_with.dart';
import 'componets/my_button.dart';
import 'componets/my_textField.dart';
import 'componets/textGesture.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.ontap});
  final Function()? ontap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool stateLogin = true;

  //Sign user in method
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text.trim(), // Ensure whitespace is trimmed
        password: passwordController.text.trim(),
      );
      setState(() {
        stateLogin = true; // If login is successful, keep stateLogin true
      });
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.message}'); // Log full error message
      setState(() {
        stateLogin = false; // Set to false on failure
      });
    }

    //Pop the circle loading
    Navigator.pop(context);
  }

  void forgotPassword() {}

  Future<UserCredential> loginWithGG() async {
    //gegin interactive sign in progess

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request 

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user 

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    // finally, lets sign in  
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
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
              if (!stateLogin) // Conditionally render error message
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
                          "Incorrect username or password",
                          style: TextStyle(color: Color(0xFFB00020)),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
                prefixIcon: Icons.person_2,
                statusLogin: stateLogin,
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                prefixIcon: Icons.password,
                statusLogin: stateLogin,
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(onTap: signUserIn, text: "LOGIN",),
              const SizedBox(
                height: 25,
              ),
              Forgotpasswordbuttom(onTap: forgotPassword),
              const SizedBox(
                height: 15,
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
              LoginWith(
                onTap: loginWithGG,
                imagePath: 'lib/Login_SignUp/Images/google.png',
                brand: 'GOOGLE',
              ),
              const SizedBox(
                height: 15,
              ),
              LoginWith(
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
                    "Don't have an account?",
                    style: TextStyle(fontSize: 15, color: Color(0xFF000000)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Textgesture(
                    text: 'Register here',
                    ontap: goToRegister,
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

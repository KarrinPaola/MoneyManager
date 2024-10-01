import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText,
       this.prefixIcon,
       this.statusLogin,  this.suffixIcon});

  final controller;
  final String hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final bool? statusLogin;
  final IconData? suffixIcon; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        style: const TextStyle(color: Color(0xFF000000)),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(
              prefixIcon,
              color: const Color(0xFF000000),
            ),
            suffixIcon: Icon(
              suffixIcon,
              color: const Color(0xff000000),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: statusLogin == false
                        ? Colors.red
                        : const Color(0xFF9ba1a8)),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: statusLogin == false
                        ? Colors.red
                        : const Color(0xFF1e42f9),
                    width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            fillColor: const Color(0xfffffffff),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
            )),
      ),
    );
  }
}

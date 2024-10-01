import 'package:flutter/material.dart';

class Forgotpasswordbuttom extends StatelessWidget {
  const Forgotpasswordbuttom({super.key, required this.onTap});

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'FORGOT PASSWORD',
            style: TextStyle(
              color: Color(0xFF9ba1a8),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

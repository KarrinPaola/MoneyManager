import 'package:flutter/material.dart';

class LoginWith extends StatelessWidget {
  const LoginWith({super.key, required this.onTap, required this.imagePath, required this.brand});

  final String imagePath;
  final String brand;

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: const Color(0xFF9ba1a8))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              width: 25,
              height: 25,
              child: Image.asset(imagePath),
            ),
            Center(
              child: Text(
                'CONTINUE WITH $brand',
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Textgesture extends StatelessWidget {
  const Textgesture({super.key, required this.text, this.ontap});

  final String text;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap, 
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1e42f9),
          fontSize: 15,
        ),
      ),
    );
  }
}

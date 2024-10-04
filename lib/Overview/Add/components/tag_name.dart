import 'package:flutter/material.dart';

class TagName extends StatelessWidget {
  const TagName(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.ontap});

  final String title;
  final bool isSelected;
  final VoidCallback ontap;

    // Getter for title
  String get getTitle => title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1e42f9) : const Color(0xffffffff),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [ BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Shadow color with opacity
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: const Offset(0, 2), // Changes position of shadow (horizontal, vertical)
              ),]
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xffffffff) : const Color(0xff000000),
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
          ),
        ),
      ),
    );
  }
}

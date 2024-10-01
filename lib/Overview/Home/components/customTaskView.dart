import 'package:flutter/material.dart';

class CustomTaskView extends StatelessWidget {
  const CustomTaskView(
      {super.key, required this.index, required this.selectedIndex});

  final num selectedIndex;
  final num index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 5,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: index == selectedIndex ? const Color(0xFF1e42f9) : const Color(0xFF9ba1a8),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

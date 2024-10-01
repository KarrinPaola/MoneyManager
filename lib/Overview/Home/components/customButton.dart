import 'package:flutter/material.dart';

class Custombutton extends StatefulWidget {
  final String title;
  final IconData iconData;
  final Function(int) onTap; // Accept a function with an integer parameter
  final int index;
  final int selectedIndex; // Add an index to know which button is pressed

  const Custombutton({
    super.key,
    required this.title,
    required this.onTap,
    required this.iconData,
    required this.index,
    required this.selectedIndex, // Required index
  });

  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.index); // Call the onTap method with the index
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.width / 4 / 2,
        decoration: BoxDecoration(
          color: widget.index == widget.selectedIndex
              ? const Color(0xFF1e42f9)
              : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            widget.index == widget.selectedIndex
                ? BoxShadow(
                    color: const Color(0xFF1e42f9).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                : BoxShadow(
                    color: const Color(0xFFedeff1).withOpacity(1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.iconData,
              color: widget.index == widget.selectedIndex
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF000000),
              size: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: widget.index == widget.selectedIndex
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF000000),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
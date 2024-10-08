import 'package:flutter/material.dart';

class Textfields extends StatefulWidget {
  const Textfields(
      {super.key,
      required this.Title,
      required this.hintText,
      this.controller,
      this.iconData,
      required this.isType,
      this.onTap,
      required this.onlyNumber});

  final String Title;
  final String hintText;
  final controller;
  final IconData? iconData;
  final Function()? onTap;
  final bool isType;
  final bool onlyNumber;

  @override
  State<Textfields> createState() => _TextfieldsState();
}

class _TextfieldsState extends State<Textfields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.Title,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 153, 172, 193),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextField(
            
            keyboardType:
                widget.onlyNumber ? TextInputType.number : TextInputType.text,
            enabled: widget.isType,
            style: const TextStyle(
              color: Color(0xff000000),
            ),
            controller: widget.controller,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: widget.onTap,
                child: Icon(
                  widget.iconData,
                  color: const Color(0xFF9ba1a8),
                ),
              ),
              hintText: widget.hintText,
              fillColor: const Color(0xffffffff),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.isType
                      ? const Color(0xFF9ba1a8)
                      : const Color(0xFF1e42f9),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              // Khi TextField được chọn (focus)
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      const Color.fromARGB(255, 55, 187, 216),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

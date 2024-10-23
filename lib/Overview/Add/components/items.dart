import 'package:flutter/material.dart';

Widget buildItem(String title, String date, String amount, String tagName) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
    child: Row(
      children: [
        const Icon(Icons.money,
            color: Color(0xFF000000)),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              softWrap: true, // Cho phép text tự động xuống dòng
              overflow: TextOverflow.visible, // Đảm bảo không cắt bớt text
            ),
            Text(date, style: const TextStyle(color: Color(0xFF9ba1a8))),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Text(tagName, style: const TextStyle(color: Color(0xFF9ba1a8))),
          ],
        ), // Tag hiển thị
      ],
    ),
  );
}

import 'package:flutter/material.dart';

Widget buildItem(String title, String date, String amount, String tagName) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.money,
              color: Color(0xFF000000)), // Biểu tượng tiền
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              softWrap: true, // Cho phép text tự động xuống dòng
              overflow: TextOverflow.visible, // Đảm bảo không cắt bớt text
            ),
            Text(date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: const TextStyle(color: Colors.green)),
            Text(tagName, style: const TextStyle(color: Colors.blue)),
          ],
        ), // Tag hiển thị
      ],
    ),
  );
}

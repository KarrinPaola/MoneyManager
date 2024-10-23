import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Add/components/items.dart';

Widget BuildListHome(
    int selectedIndex,
    List<Map<String, String>> incomeItems,
    List<Map<String, String>> expenseItems,
    List<Map<String, String>> remindItems) {
  switch (selectedIndex) {
    case 0:
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: incomeItems.length,
        itemBuilder: (context, index) {
          return buildItem(
            incomeItems[index]['title'] ?? '',
            incomeItems[index]['date'] ?? '',
            incomeItems[index]['amount'] ?? '',
            incomeItems[index]['tag'] ?? '',
          );
        },
      );
    case 1:
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: incomeItems.length,
        itemBuilder: (context, index) {
          return buildItem(
            expenseItems[index]['title'] ?? '',
            expenseItems[index]['date'] ?? '',
            expenseItems[index]['amount'] ?? '',
            expenseItems[index]['tag'] ?? '',
          );
        },
      );
    case 2:
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: incomeItems.length,
        itemBuilder: (context, index) {
          return buildItem(
            remindItems[index]['title'] ?? '',
            remindItems[index]['date'] ?? '',
            remindItems[index]['amount'] ?? '',
            remindItems[index]['tag'] ?? '',
          );
        },
      );
    default:
      return Container(); // Nếu không khớp giá trị nào
  }
}

import 'package:flutter/material.dart';

import '../../Add/components/items.dart';

Widget BuildListHome(
    int selectedIndex,
    List<Map<String, String>> incomeItems,
    List<Map<String, String>> expenseItems,
    List<Map<String, String>> remindItems, 
    bool isLogined) {
  switch (selectedIndex) {
    case 2:
      return incomeItems.isNotEmpty
          ? ListView.builder(
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
            )
          : Center(child: Text('Chưa có dữ liệu'));
    case 0:
      return expenseItems.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: expenseItems.length,
              itemBuilder: (context, index) {
                return buildItem(
                  expenseItems[index]['title'] ?? '',
                  expenseItems[index]['date'] ?? '',
                  expenseItems[index]['amount'] ?? '',
                  expenseItems[index]['tag'] ?? '',
                );
              },
            )
          : Center(child: Text('Chưa có dữ liệu'));
    case 1:
      return remindItems.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: remindItems.length,
              itemBuilder: (context, index) {
                return buildItem(
                  remindItems[index]['title'] ?? '',
                  remindItems[index]['date'] ?? '',
                  remindItems[index]['amount'] ?? '',
                  remindItems[index]['tag'] ?? '',
                );
              },
            )
          : Center(child: Text('Chưa có dữ liệu'));
    default:
      return Container(); // Nếu không khớp giá trị nào
  }
}
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
                return ItemWidget(
                  title: incomeItems[index]['title'] ?? '',
                  date:incomeItems[index]['date'] ?? '',
                  amount:incomeItems[index]['amount'] ?? '',
                  tagName: incomeItems[index]['tag'] ?? '',
                  onDelete: (){},
                );
              },
            )
          : const Center(child: Text('Chưa có dữ liệu'));
    case 0:
      return expenseItems.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: expenseItems.length,
              itemBuilder: (context, index) {
                return ItemWidget(
                  title: expenseItems[index]['title'] ?? '',
                  date: expenseItems[index]['date'] ?? '',
                  amount: expenseItems[index]['amount'] ?? '',
                  tagName: expenseItems[index]['tag'] ?? '',
                                    onDelete: (){},
                );
              },
            )
          : const Center(child: Text('Chưa có dữ liệu'));
    case 1:
      return remindItems.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: remindItems.length,
              itemBuilder: (context, index) {
                return ItemWidget(
                  title: remindItems[index]['title'] ?? '',
                  date:remindItems[index]['date'] ?? '',
                  amount:remindItems[index]['amount'] ?? '',
                  tagName:remindItems[index]['tag'] ?? '',
                                    onDelete: (){},
                );
              },
            )
          : const Center(child: Text('Chưa có dữ liệu'));
    default:
      return Container(); // Nếu không khớp giá trị nào
  }
}
import 'package:flutter/material.dart';

import '../widgets/goal_item.dart';
import 'add_money_screen.dart'; // Import màn hình AddMoneyScreen

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allGoals = [
      {'name': 'New Bike', 'saved': 300, 'goal': 600},
      {'name': 'Iphone 15 Pro', 'saved': 700, 'goal': 1000},
      // Thêm các mục tiêu khác
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Goals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: allGoals.map((goal) {
          return GestureDetector(
            onTap: () {
              // Tạo TextEditingController trước khi chuyển đến AddMoneyScreen
              TextEditingController amountController = TextEditingController();

              // Chuyển đến màn hình AddMoneyScreen và truyền dữ liệu cần thiết
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMoneyScreen(
                    goalName: goal['name'] as String,
                    currentSaved: goal['saved'] as double,
                    goalAmount: goal['goal'] as double,
                    amountController: amountController, // Truyền TextEditingController
                  ),
                ),
              );
            },
            child: GoalItem(goal: goal), // Hiển thị chi tiết mục tiêu
          );
        }).toList(),
      ),
    );
  }
}

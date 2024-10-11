
import 'package:flutter/material.dart';

import '../../add_goal/goal/add_goals.dart';
import '../widgets/goals_widget.dart';
import '../widgets/savings_widget.dart';
import 'goals_screen.dart';

class SavingsHomeScreen extends StatelessWidget {
  const SavingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Savings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16), // Canh phải
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.black, // Dấu cộng màu trắng
              onPressed: () {
                print('Add new savings');
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddGoals()),
                  );
                // Thêm hành động mở màn hình mới hoặc thực hiện tác vụ
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SavingsWidget(currentSavings: 800),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GoalsWidget(
                goals: const [
                  {'name': 'New Bike', 'saved': 300, 'goal': 600},
                  {'name': 'Iphone 15 Pro', 'saved': 700, 'goal': 1000},
                ],
                onMoreGoalsTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoalsScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

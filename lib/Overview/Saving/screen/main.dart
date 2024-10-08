import 'package:back_up/Overview/Saving/add_goal/goal/add_goals.dart';
import 'package:flutter/material.dart';

import 'screens/goals_screen.dart';
import 'widgets/goals_widget.dart';
import 'widgets/savings_widget.dart';

void main() {
  runApp(Screen());
}

class Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savings App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            Color(0xFFFFFFFF), // Màu nền toàn bộ là #FFFFFF
      ),
      home: SavingsHomeScreen(),
    );
  }
}

class SavingsHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Savings App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add), // Biểu tượng dấu cộng
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGoals()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F6F7), // Màu nền trắng
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50), // Khoảng cách phía trên
            Center(
              child: SavingsWidget(currentSavings: 800), // Giao diện tiết kiệm
            ),
            SizedBox(height: 30),
            Expanded(
              child: GoalsWidget(
                goals: [
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

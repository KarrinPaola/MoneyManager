import 'package:flutter/material.dart';
import '../widgets/goal_item.dart';

class GoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allGoals = [
      {'name': 'New Bike', 'saved': 300, 'goal': 600},
      {'name': 'Iphone 15 Pro', 'saved': 700, 'goal': 1000},
      // Thêm các mục tiêu khác
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('All Goals'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: allGoals.map((goal) => GoalItem(goal: goal)).toList(),
      ),
    );
  }
}

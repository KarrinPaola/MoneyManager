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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Goals'),
            // Nút dấu cộng nằm ở bên phải tiêu đề
            InkWell(
              onTap: () {
                // Hành động khi ấn nút dấu cộng
                print('Add new goal');
                // Bạn có thể thêm logic mở một màn hình hoặc thêm mục tiêu tại đây
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2144FA), // Màu xanh dương
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.add,
                  color: Colors.white, // Màu trắng cho dấu cộng
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: allGoals.map((goal) => GoalItem(goal: goal)).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/savings_widget.dart';
import '../widgets/goals_widget.dart';
import 'goals_screen.dart';

class SavingsHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Savings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16), // Canh phải
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue), // Viền xanh
              shape: BoxShape.circle,
              color: Colors.blue, // Nền xanh
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              color: Colors.white, // Dấu cộng màu trắng
              onPressed: () {
                print('Add new savings');
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

import 'package:flutter/material.dart';
import '../widgets/savings_widget.dart';
import '../widgets/goals_widget.dart';
import 'goals_screen.dart';

class SavingsHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
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

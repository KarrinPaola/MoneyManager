import 'package:flutter/material.dart';
import 'goal_item.dart';

class GoalsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> goals;
  final VoidCallback onMoreGoalsTap;

  GoalsWidget({required this.goals, required this.onMoreGoalsTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Goals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: onMoreGoalsTap,
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: goals.map((goal) => GoalItem(goal: goal)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

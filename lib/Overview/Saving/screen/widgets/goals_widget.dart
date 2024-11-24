import 'package:flutter/material.dart';

import 'goal_item.dart';

class GoalsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> goals;
  final VoidCallback onMoreGoalsTap;

  const GoalsWidget({
    super.key,
    required this.goals,
    required this.onMoreGoalsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
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
                const Text(
                  'Your Goals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: onMoreGoalsTap, // Chuyển đến trang hiển thị nhiều mục tiêu hơn
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: goals.map((goal) {
                return GestureDetector(
                  onTap: () {
                    // Dữ liệu sẽ được gửi đến AddMoneyScreen thông qua Navigator.push
                    String goalName = goal['name'] as String;
                    double currentSaved = goal['saved'] as double;
                    double goalAmount = goal['goal'] as double;

                    // Tạo TextEditingController để truyền sang AddMoneyScreen
                    TextEditingController amountController = TextEditingController();

                    // Gửi dữ liệu thông qua Navigator.push
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AddMoneyScreen(
                    //       goalName: goalName,
                    //       currentSaved: currentSaved,
                    //       goalAmount: goalAmount,
                    //       amountController: amountController, // Truyền TextEditingController
                    //     ),
                    //   ),
                    // );
                  },
                  child: GoalItem(goal: goal), // Hiển thị chi tiết mục tiêu
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

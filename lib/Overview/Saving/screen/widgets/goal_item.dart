import 'package:flutter/material.dart';

class GoalItem extends StatelessWidget {
  final Map<String, dynamic> goal;

  const GoalItem({super.key, required this.goal, });

  @override
  Widget build(BuildContext context) {
    double progress = goal['saved'] / goal['goal'];

    // Lựa chọn icon dựa trên tên mục tiêu
    IconData icon;
    if (goal['name'] == 'New Bike') {
      icon = Icons.directions_bike; // Icon bike
    } else if (goal['name'] == 'Iphone 15 Pro') {
      icon = Icons.phone_iphone; // Icon điện thoại
    } else {
      icon = Icons.help_outline; // Icon mặc định nếu không khớp
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Hiển thị icon mục tiêu
          Icon(icon, size: 40, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị tên mục tiêu
                Text(
                  goal['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // Thanh tiến độ
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: const Color(0xFF2144FA),
                ),
                const SizedBox(height: 5),
                // Hiển thị số tiền đã tiết kiệm và mục tiêu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${goal['saved']}',
                        style: TextStyle(color: Colors.grey.shade600)),
                    Text('\$${goal['goal']}',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

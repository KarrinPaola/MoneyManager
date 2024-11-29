import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalItem extends StatelessWidget {
  final Map<String, dynamic> goal;

  const GoalItem({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    // Tính tiến độ
    double progress = goal['currentAmount'] / goal['totalAmount'];

    // Định dạng số tiền
    final currencyFormatter = NumberFormat('#,##0', 'vi_VN');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị tên mục tiêu
                Text(
                  goal['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
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
                    // Số tiền hiện tại
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${currencyFormatter.format(goal['currentAmount'])} ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'đ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Số tiền mục tiêu
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${currencyFormatter.format(goal['totalAmount'])} ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'đ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
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

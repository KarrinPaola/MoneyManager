import 'package:flutter/material.dart';

class SavingsWidget extends StatelessWidget {
  final double currentSavings;

  const SavingsWidget({super.key, required this.currentSavings});

  @override
  Widget build(BuildContext context) {
    double savedAmount = 200;
    double goalAmount = 500;

    return Column(
      children: [
        // Phần chữ "Current Savings"
        Text(
          'Current Savings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 10),
        // Hình tròn hiển thị số tiền với bóng đổ và màu sắc tùy chỉnh
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2144FA), // Màu mới
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // Màu bóng đổ nhẹ
                blurRadius: 10,
                offset: Offset(0, 5), // Đổ bóng nhẹ xuống dưới
              ),
            ],
          ),
          child: Center(
            child: Text(
              '\$$currentSavings',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Chữ trắng nổi bật
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Mục tiêu tháng với thanh trượt lớn hơn
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white, // Màu trắng cho widget
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3), // Đổ bóng nhẹ cho widget
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      const Text(
                        'July 2024',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Goal for this Month',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  // Thanh trượt lớn hơn
                  Container(
                    height: 30, // Tăng chiều cao của thanh trượt
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Màu nền thanh trượt
                      borderRadius:
                          BorderRadius.circular(16), // Bo góc cho thanh trượt
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: savedAmount.toInt(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFF2144FA), // Màu của phần đã tiết kiệm
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: (goalAmount - savedAmount).toInt(),
                          child: Container(), // Phần chưa đạt mục tiêu
                        ),
                      ],
                    ),
                  ),
                  // Hiển thị giá trị hiện tại và mục tiêu
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '\$$savedAmount',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Màu chữ trắng
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '\$$goalAmount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.grey.shade600, // Màu chữ của mục tiêu
                            ),
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
    );
  }
}

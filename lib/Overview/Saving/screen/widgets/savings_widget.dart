import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm import intl

class SavingsWidget extends StatelessWidget {
  final double totalAmountSum;
  final double currentAmountSum;

  const SavingsWidget({
    Key? key,
    required this.totalAmountSum,
    required this.currentAmountSum,
    required String totalText,
    required String currentText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy tháng và năm hiện tại
    String currentMonthYear = '${DateTime.now().month}/${DateTime.now().year}';

    // Định dạng số tiền
    var currencyFormatter = NumberFormat('#,##0', 'vi_VN'); // Định dạng tiền tệ với dấu phẩy ngăn cách

    // Kiểm tra xem currentAmountSum có lớn hơn totalAmountSum không
    Color progressBarColor = currentAmountSum > totalAmountSum
        ? Colors.red // Nếu vượt quá, màu sẽ là đỏ
        : const Color(0xFF2144FA); // Màu mặc định là xanh dương

    return Column(
      children: [
        const SizedBox(height: 10),
        // Circular display for the current amount sum
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2144FA),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: FittedBox(  // Đảm bảo số tiền không bị tràn
              child: Text(
                '${currencyFormatter.format(currentAmountSum)} VNĐ', // Số tiền trước VNĐ
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Monthly goal display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Text(
                        currentMonthYear, // Sử dụng tháng và năm hiện tại
                        style: const TextStyle(
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
                  'Số tiền mục tiêu tại tháng này',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  // Progress bar
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: currentAmountSum.toInt(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: progressBarColor, // Đổi màu thanh tiến độ
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: (totalAmountSum - currentAmountSum).toInt(),
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  // Displaying current and total amounts
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: FittedBox(  // Đảm bảo số tiền không bị tràn
                            child: Text(
                              '${currencyFormatter.format(currentAmountSum)} VNĐ', // Định dạng tiền VNĐ
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: FittedBox(  // Đảm bảo số tiền không bị tràn
                            child: Text(
                              '${currencyFormatter.format(totalAmountSum)} VNĐ', // Định dạng tiền VNĐ
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 224, 216, 216),
                              ),
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

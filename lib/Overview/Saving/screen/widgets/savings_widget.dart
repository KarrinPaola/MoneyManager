import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    var currencyFormatter = NumberFormat('#,##0', 'vi_VN');

    // Kiểm tra màu sắc cho thanh tiến độ
    Color progressBarColor = currentAmountSum > totalAmountSum
        ? Colors.red // Nếu vượt quá, màu sẽ là đỏ
        : const Color(0xFF2144FA); // Mặc định là xanh dương

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        // Hộp chứa số tiền hiện tại
        Container(
          width: 200, // Chiều rộng lớn hơn để chứa số tiền dài
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF2144FA),
            borderRadius: BorderRadius.circular(50), // Tăng độ bo góc lớn hơn
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${currencyFormatter.format(currentAmountSum)} ', // Hiển thị số tiền
                    style: const TextStyle(
                      fontSize: 24, // Kích thước cố định
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'đ', // Hiển thị "đ"
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline, // Gạch chân dưới chữ "đ"
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis, // Cắt chữ nếu quá dài
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Mục tiêu hàng tháng
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32), // Tăng độ bo góc cho container
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
                        currentMonthYear,
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
                  'Tổng sồ tiền mục tiêu',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  // Thanh tiến độ
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(32), // Tăng độ bo góc của thanh tiến độ
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: currentAmountSum.toInt(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: progressBarColor,
                              borderRadius: BorderRadius.circular(32), // Tăng độ bo góc của phần màu
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
                  // Hiển thị số tiền hiện tại và tổng số tiền
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${currencyFormatter.format(currentAmountSum)} ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'đ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${currencyFormatter.format(totalAmountSum)} ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'đ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
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

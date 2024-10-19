import 'package:flutter/material.dart';

class AddMoneyScreen extends StatelessWidget {
  final String goalName;
  final double currentSaved;
  final double goalAmount;
  final TextEditingController amountController; // Truyền từ bên ngoài

  // Chấp nhận TextEditingController từ bên ngoài để dễ dàng quản lý
  AddMoneyScreen({
    super.key,
    required this.goalName,
    required this.currentSaved,
    required this.goalAmount,
    required this.amountController, // Bắt buộc phải truyền controller
  });

  @override
  Widget build(BuildContext context) {
    // Tính toán tỷ lệ phần trăm đã tiết kiệm được
    double progress = currentSaved / goalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Money'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị mục tiêu và số tiền với thanh tiến độ
            Text(
              goalName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Thanh tiến độ và số tiền
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress, // Giá trị tiến độ
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFF2548FB), // Màu xanh giống trong hình
                    minHeight: 6,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${currentSaved.toStringAsFixed(2)}', // Số tiền đã tiết kiệm
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\$${goalAmount.toStringAsFixed(2)}', // Mục tiêu số tiền
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Phần nhập số tiền thêm vào
            const Text(
              'Enter Amount to Add',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController, // Sử dụng controller từ bên ngoài
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 20),

            // Nút xác nhận với màu nền #2548FB và chữ trắng
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2548FB), // Màu nền nút
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  final amount = double.tryParse(amountController.text);
                  if (amount != null && amount > 0) {
                    // Hiển thị AlertDialog thông báo thành công
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: Text('You have successfully added \$${amountController.text} to your goal.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng AlertDialog
                                Navigator.pop(context, amount); // Trả về số tiền đã nhập và đóng màn hình
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Hiển thị thông báo khi nhập không hợp lệ
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Invalid Input'),
                          content: const Text('Please enter a valid amount.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  'Add Money',
                  style: TextStyle(color: Colors.white), // Màu chữ trắng
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

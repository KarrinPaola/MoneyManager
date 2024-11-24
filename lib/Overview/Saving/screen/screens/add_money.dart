import 'package:back_up/userID_Store.dart';
import 'package:flutter/material.dart';

import '../components/add_money_data.dart';

class AddMoneyScreen extends StatefulWidget {
  final Map<String, dynamic> goal; // Dữ liệu mục tiêu được truyền vào để chỉnh sửa

  const AddMoneyScreen({Key? key, required this.goal}) : super(key: key);

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController currentSavedController;
  bool update = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.goal['title'] ?? '');
    amountController = TextEditingController(text: widget.goal['goalAmount']?.toString() ?? '');
    currentSavedController = TextEditingController(text: widget.goal['currentSaved']?.toString() ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    currentSavedController.dispose();
    super.dispose();
  }

  Future<void> _updateGoalInDatabase() async {
    try {
      if (titleController.text.isEmpty || amountController.text.isEmpty || currentSavedController.text.isEmpty) {
        _showErrorDialog("Vui lòng điền đầy đủ các trường");
        return;
      }

      double goalAmount = double.parse(amountController.text);
      double currentSaved = double.parse(currentSavedController.text);

      if (goalAmount < currentSaved) {
        _showErrorDialog("Số tiền mục tiêu không thể nhỏ hơn số tiền hiện tại đã tiết kiệm.");
        return;
      }

      await AddMoneyDatabase(
        UserStorage.userId!,
        widget.goal['id'],
        titleController.text,
        goalAmount,
        currentSaved,
      );

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog("Không thể cập nhật mục tiêu: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cập nhật thành công"),
        content: const Text("Mục tiêu của bạn đã được cập nhật thành công."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, update);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, update);
            update = false;
          },
        ),
        title: const Text(
          'Chỉnh sửa mục tiêu',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField cho Tiêu đề Mục tiêu
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                labelStyle: const TextStyle(color: Colors.black), // Màu chữ của nhãn
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Viền màu đen khi chọn
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Viền màu xám khi không chọn
                ),
              ),
              cursorColor: Colors.black,
            ),
            const SizedBox(height: 10),

            // TextField cho Số tiền mục tiêu
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số tiền mục tiêu',
                labelStyle: const TextStyle(color: Colors.black), // Màu chữ của nhãn
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // TextField cho Số tiền đã tiết kiệm
            TextField(
              controller: currentSavedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số tiền đã tiết kiệm',
                labelStyle: const TextStyle(color: Colors.black), // Màu chữ của nhãn
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.savings),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              cursorColor: Colors.black,
            ),
            const SizedBox(height: 20),

            // Nút cập nhật mục tiêu
            ElevatedButton(
              onPressed: () async {
                await _updateGoalInDatabase();
                update = true;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1e42f9),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'CẬP NHẬT',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

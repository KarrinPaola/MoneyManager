import 'package:back_up/userID_Store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng số

import '../components/add_money_data.dart';

class AddMoneyScreen extends StatefulWidget {
  final Map<String, dynamic> goal;

  const AddMoneyScreen({Key? key, required this.goal}) : super(key: key);

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  late TextEditingController addMoneyController;
  bool update = false;

  @override
  void initState() {
    super.initState();
    addMoneyController = TextEditingController();
  }

  @override
  void dispose() {
    addMoneyController.dispose();
    super.dispose();
  }

  /// Hàm xử lý hiển thị số tiền có dấu phẩy
  String formatCurrency(String value) {
    final formatter = NumberFormat("#,###"); // Định dạng với dấu phẩy
    try {
      // Loại bỏ các ký tự không phải số, rồi định dạng lại
      final number = int.parse(value.replaceAll(RegExp(r'[^\d]'), ''));
      return formatter.format(number);
    } catch (e) {
      return value; // Nếu không thể parse, trả về nguyên gốc
    }
  }

  /// Hàm xử lý chuyển từ chuỗi định dạng sang giá trị số thực
  double parseCurrency(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0;
  }

  Future<void> _updateGoalInDatabase(double amountToAdd) async {
    try {
      double currentSaved = widget.goal['currentAmount'] != null
          ? (widget.goal['currentAmount'] as num).toDouble()
          : 0.0;

      // Cộng thêm số tiền mới
      currentSaved += amountToAdd;

      // Gọi hàm cập nhật cơ sở dữ liệu
      await AddMoneyDatabase(
        UserStorage.userId!,
        widget.goal['id'],
        widget.goal['title'],
        currentSaved, // Chỉ truyền `currentSaved`
      );

      // Cập nhật trạng thái để đồng bộ hiển thị
      setState(() {
        widget.goal['currentAmount'] = currentSaved;
      });

      // Hiển thị thông báo thành công
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
        backgroundColor: Colors.white,
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
    final String goalTitle = widget.goal['title'] ?? "Không có tiêu đề";
    final double currentSaved = widget.goal['currentAmount'] != null
        ? (widget.goal['currentAmount'] as num).toDouble()
        : 0.0;

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
            Text(
              'Với mục tiêu "$goalTitle", bạn đã tiết kiệm được:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Số tiền đã tiết kiệm:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${currentSaved.toStringAsFixed(0)} VND',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: addMoneyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Thêm số tiền muốn tiết kiệm',
                labelStyle: const TextStyle(color: Colors.black),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.add_circle_outline),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                // Cập nhật giá trị hiển thị khi người dùng nhập
                final formattedValue = formatCurrency(value);
                addMoneyController.value = TextEditingValue(
                  text: formattedValue,
                  selection: TextSelection.collapsed(offset: formattedValue.length),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Lấy giá trị thực từ input (bỏ dấu phẩy)
                final input = addMoneyController.text;
                double amountToAdd = parseCurrency(input);

                if (amountToAdd <= 0) {
                  _showErrorDialog("Số tiền thêm phải lớn hơn 0.");
                  return;
                }

                // Cập nhật cơ sở dữ liệu
                await _updateGoalInDatabase(amountToAdd);
                update = true;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1e42f9),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'XÁC NHẬN',
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

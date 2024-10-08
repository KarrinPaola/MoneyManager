import 'package:back_up/Overview/Saving/add_goal/goal/deadline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày
// Nhớ import DeadlineLogic

class DeadlineField extends StatefulWidget {
  final TextEditingController controller;

  // Nhận controller từ widget cha
  DeadlineField({required this.controller});

  @override
  _DeadlineFieldState createState() => _DeadlineFieldState();
}

class _DeadlineFieldState extends State<DeadlineField> {
  final DeadlineLogic _deadlineLogic = DeadlineLogic(); // Khởi tạo lớp logic

  @override
  Widget build(BuildContext context) {
    return Container(  // Thêm Container để bảo đảm kích thước
      padding: const EdgeInsets.all(10), // Padding cho container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deadline',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 172, 193),
            ),
          ),
          const SizedBox(height: 5),
          // Đặt chiều cao cho TextField bằng SizedBox
          SizedBox(
            height: 60, // Đặt chiều cao cụ thể
            child: TextField(
              controller: widget.controller,
              readOnly: true,
              onTap: () async {
                // Gọi logic chọn ngày
                await _deadlineLogic.selectDate(context, (DateTime? selectedDate) {
                  setState(() {
                    // Cập nhật controller sau khi chọn ngày
                    if (selectedDate != null) {
                      widget.controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                    }
                  });
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF9ba1a8),
                ),
                hintText: _deadlineLogic.selectedDate == null
                    ? 'Chọn Deadline'
                    : DateFormat('dd/MM/yyyy').format(_deadlineLogic.selectedDate!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

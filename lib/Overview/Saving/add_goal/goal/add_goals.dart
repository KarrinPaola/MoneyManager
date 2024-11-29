import 'package:back_up/Overview/Saving/add_goal/components/add_goal_database.dart';
import 'package:back_up/Overview/Saving/add_goal/components/deadlinefield.dart';
import 'package:back_up/Overview/Saving/add_goal/components/textfields.dart';
import 'package:back_up/Overview/Saving/add_goal/goal/contribute_type.dart';
import 'package:back_up/userID_Store.dart';
import 'package:flutter/material.dart';

class AddGoals extends StatefulWidget {
  const AddGoals({super.key});

  @override
  _AddGoalsState createState() => _AddGoalsState();
}

class _AddGoalsState extends State<AddGoals> {
  // Controllers for the fields
  final TextEditingController goalTitleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController contributionTypeController =
      TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  bool update = false;

  @override
  void dispose() {
    // Dispose of controllers when not needed
    goalTitleController.dispose();
    amountController.dispose();
    contributionTypeController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  Future<void> _addGoalToDatabase() async {
    try {
      // Kiểm tra các trường dữ liệu
      if (goalTitleController.text.isEmpty ||
          amountController.text.isEmpty ||
          contributionTypeController.text.isEmpty ||
          deadlineController.text.isEmpty) {
        _showErrorDialog("Please fill in all fields");
        return;
      }

      // Thêm dữ liệu vào Firestore
      await AddGoalsDatabase(
        UserStorage.userId!,
        goalTitleController.text,
        double.parse(amountController.text),
        contributionTypeController.text,
        selectedDay,
      );

      // Hiển thị AlertDialog sau khi thêm thành công
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog("Failed to add goal: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
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
        title: const Text("Mục tiêu đã hoàn tất"),
        content: const Text("Mục tiêu của bạn đã được thêm."),
        backgroundColor: Colors.white,
        actions: [
          // Nút tiếp tục thêm mới
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              goalTitleController.clear();
              amountController.clear();
              contributionTypeController.clear();
              deadlineController.clear();
              setState(() {
                selectedDay = DateTime.now(); // Reset deadline
              });
            },
            child: const Text("Thêm mục tiêu"),
          ),
          // Nút quay lại màn hình trước
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context, update); // Quay lại màn hình trước
            },
            child: const Text("Trở lại"),
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
            update = false; // Quay lại màn hình trước đó
          },
        ),
        title: const Text(
          'Nhập mục tiêu',
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
            // Goal Title Text Field
            Textfields(
              Title: 'Mục tiêu',
              hintText: 'Nhập mục tiêu của bạn',
              isType: true,
              onlyNumber: false,
              controller: goalTitleController,
            ),
            const SizedBox(height: 10),

            // Amount Text Field
            Textfields(
              Title: 'Số tiền mục tiêu',
              hintText: 'Nhập số tiền mục tiêu',
              isType: true,
              onlyNumber: true,
              controller: amountController,
            ),
            const SizedBox(height: 10),

            // Contribution Type Field
            ContributionTypeField(
              controller: contributionTypeController,
            ),
            const SizedBox(height: 10),

            // Deadline Field
            DeadlineField(
              controller: deadlineController,
              selectedDay: selectedDay,
            ),
            const SizedBox(height: 20),

            // Button to add goal
            ElevatedButton(
              onPressed: () async {
                await _addGoalToDatabase();
                update = true; // Cập nhật trạng thái
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1e42f9),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Xác nhận',
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

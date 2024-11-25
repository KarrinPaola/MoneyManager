import 'package:back_up/Overview/Saving/add_goal/goal/add_goals.dart';
import 'package:back_up/Overview/Saving/screen/components/load_data.dart';
import 'package:back_up/Overview/Saving/screen/screens/add_money.dart';
import 'package:back_up/Overview/Saving/screen/widgets/goal_item.dart';
import 'package:back_up/userID_Store.dart';
import 'package:flutter/material.dart';

import '../components/Service.dart';
import '../widgets/savings_widget.dart';

class SavingsHomeScreen extends StatefulWidget {
  const SavingsHomeScreen({super.key});

  @override
  _SavingsHomeScreenState createState() => _SavingsHomeScreenState();
}

class _SavingsHomeScreenState extends State<SavingsHomeScreen> {
  final SavingService savingService = SavingService();
  final FirestoreService firestoreService = FirestoreService();
  double totalAmountSum = 0.0;
  double currentAmountSum = 0.0;
  List<Map<String, dynamic>> savingsList = [];
  Set<String> ignoredGoals =
      {}; // Set to keep track of goals with canceled alerts.

  @override
  void initState() {
    super.initState();
    _loadIgnoredGoals(); // Load ignored goals from SharedPreferences
    _loadDataTotalAmount();
    _loadDataCurrentAmount();
    _loadDataSavingList();
  }

  // Hàm hiển thị thông báo khi mục tiêu đã hoàn thành
  void _showCompletionDialog(goal, double surplus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chúc mừng!"),
        content: const Text("Mục tiêu của bạn đã hoàn thành!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  // Lấy danh sách mục tiêu bị bỏ qua từ Firestore
  Future<void> _loadIgnoredGoals() async {
    String? userId = UserStorage.userId;
    List<String> goals = await firestoreService.getIgnoredGoals(userId!);
    setState(() {
      ignoredGoals = goals.toSet();
    });
  }

  // Lưu ID mục tiêu đã hủy vào Firestore
  Future<void> _saveIgnoredGoal(String goalId) async {
    String? userId = UserStorage.userId;
    await firestoreService.addIgnoredGoal(userId!, goalId);
  }

  // Hàm tải dữ liệu tổng số tiền
  Future<void> _loadDataTotalAmount() async {
    String? userId = UserStorage.userId;
    double temp = await savingService.getTotalAmount(userId!);
    setState(() {
      totalAmountSum = temp;
    });
  }

  // Hàm tải dữ liệu số tiền đã tiết kiệm
  Future<void> _loadDataCurrentAmount() async {
    String? userId = UserStorage.userId;
    double temp = await savingService.getTotalCurrentAmount(userId!);
    setState(() {
      currentAmountSum = temp;
    });
  }

  // Hàm tải danh sách các mục tiêu tiết kiệm
  Future<void> _loadDataSavingList() async {
    String? userId = UserStorage.userId;
    List<Map<String, dynamic>> temp =
        await savingService.getAllSavings(userId!);
    setState(() {
      savingsList = temp;
    });

    // Kiểm tra xem có mục tiêu nào cần hiển thị alert không
    _checkForAlertDialog();
  }

  // Hàm kiểm tra và hiển thị AlertDialog nếu currentAmount lớn hơn totalAmount
  void _checkForAlertDialog() {
    for (var goal in savingsList) {
      if (!ignoredGoals.contains(goal['id']) &&
          goal['currentAmount'] > goal['totalAmount']) {
        _showAmountExceedDialog(goal['id']);
      }
    }
  }

  // Hiển thị thông báo khi người dùng bấm hủy
  void _showAmountExceedDialog(String goalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Số tiền đã vượt quá mục tiêu'),
          content: const Text('Bạn có muốn hủy hoặc chuyển tiền?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Lưu ID mục tiêu vào Firestore khi bấm hủy
                setState(() {
                  ignoredGoals.add(goalId);
                });
                _saveIgnoredGoal(goalId); // Lưu vào Firestore
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Logic chuyển tiền (nếu cần)
              },
              child: const Text('Chuyển tiền'),
            ),
          ],
        );
      },
    );
  }

  void checkForAlertDialog() {
    for (var goal in savingsList) {
      // Kiểm tra nếu 'currentAmount' và 'totalAmount' không phải null và chuyển thành double nếu cần
      double currentAmount =
          (goal['currentAmount'] != null && goal['currentAmount'] is num)
              ? (goal['currentAmount'] is double
                  ? goal['currentAmount']
                  : (goal['currentAmount'] as num).toDouble())
              : 0.0; // Default to 0.0 if invalid

      double totalAmount =
          (goal['totalAmount'] != null && goal['totalAmount'] is num)
              ? (goal['totalAmount'] is double
                  ? goal['totalAmount']
                  : (goal['totalAmount'] as num).toDouble())
              : 0.0; // Default to 0.0 if invalid

      // Kiểm tra nếu currentAmount lớn hơn totalAmount và mục tiêu chưa bị bỏ qua
      if (currentAmount > totalAmount && !ignoredGoals.contains(goal['id'])) {
        double surplus = currentAmount - totalAmount; // Tính số tiền thừa
        _showCompletionDialog(goal['id'], surplus); // Hiển thị thông báo
      }
    }
  }

  // Hàm xóa mục tiêu tiết kiệm
  Future<void> _deleteSaving(String id) async {
    try {
      await savingService.deleteSaving(id);
      await _loadDataTotalAmount();
      await _loadDataCurrentAmount();
      await _loadDataSavingList();
    } catch (e) {
      print('Lỗi khi xóa mục tiêu: $e');
      _showErrorDialog('Không thể xóa mục tiêu. Vui lòng thử lại.');
    }
  }

  // Hàm hiển thị lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: const Center(
          child: Text(
            'Savings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              bool? update = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddGoals(),
                ),
              );
              if (update == true) {
                _loadDataTotalAmount();
                _loadDataCurrentAmount();
                _loadDataSavingList();
              }
            },
          ),
        ],
        elevation: 0, // Remove shadow
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFedeff1),
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SavingsWidget(
                totalAmountSum: totalAmountSum,
                currentAmountSum: currentAmountSum,
                totalText: '',
                currentText: '',
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mục tiêu của bạn',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF9ba1a8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.more_horiz,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(25),
                      itemCount: savingsList.length,
                      itemBuilder: (context, index) {
                        final goal = savingsList[index];
                        return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Options'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit),
                                          title: const Text('Chỉnh sửa'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            bool? update = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddMoneyScreen(goal: goal),
                                              ),
                                            );
                                            if (update == true) {
                                              _loadDataTotalAmount();
                                              _loadDataCurrentAmount();
                                              _loadDataSavingList();
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text('Xoá'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            _deleteSaving(goal['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Transform.translate(
                              offset: const Offset(
                                  0, -18), // Di chuyển lên trên 10px (y = -10)
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom:
                                        1), // Giữ khoảng cách dưới cùng nếu cần
                                padding: const EdgeInsets.all(
                                    5), // Giữ padding như trước
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GoalItem(goal: goal),
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

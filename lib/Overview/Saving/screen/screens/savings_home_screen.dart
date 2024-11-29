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
  Set<String> ignoredGoalIds = {};
  Map<String, double> ignoredGoalAmounts = {};

  @override
  void initState() {
    super.initState();
    _loadIgnoredGoals(); // Tải ignored_goals từ Firestore
    _loadAllData(); // Tải danh sách mục tiêu
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

  Future<void> _loadIgnoredGoals() async {
    String? userId = UserStorage.userId;
    List<Map<String, dynamic>> goals =
        await firestoreService.getIgnoredGoalsWithAmounts(userId!);

    print("Dữ liệu ignored_goals tải về: $goals");

    setState(() {
      ignoredGoalIds = goals.map((goal) => goal['id'].toString()).toSet();
      ignoredGoalAmounts = {
        for (var goal in goals)
          goal['id'].toString(): goal['currentAmount'] as double
      };
    });
  }

  Future<void> _saveIgnoredGoal(String goalId, double currentAmount) async {
    String? userId = UserStorage.userId;
    await firestoreService.addIgnoredGoalWithAmount(
        userId!, goalId, currentAmount);
  }

  Future<void> _loadAllData() async {
    String? userId = UserStorage.userId;

    // Tải tổng số tiền đã tiết kiệm
    double totalAmount = await savingService.getTotalAmount(userId!);

    // Tải số tiền hiện tại
    double currentAmount = await savingService.getTotalCurrentAmount(userId);

    // Tải danh sách các mục tiêu tiết kiệm
    List<Map<String, dynamic>> savingsListData =
        await savingService.getAllSavings(userId);

    // Cập nhật UI
    setState(() {
      totalAmountSum = totalAmount;
      currentAmountSum = currentAmount;
      savingsList = savingsListData;
    });

    // Kiểm tra và hiển thị alert nếu cần
    _checkForAlertDialog();
  }

  // Hàm tải dữ liệu tổng số tiền

  void _checkForAlertDialog() {
    for (var goal in savingsList) {
      String goalId = goal['id'];
      double currentAmount = goal['currentAmount'] ?? 0.0;
      double totalAmount = goal['totalAmount'] ?? 0.0;

      if (currentAmount > totalAmount &&
          (!ignoredGoalIds.contains(goalId) ||
              ignoredGoalAmounts[goalId] != currentAmount)) {
        _showAmountExceedDialog(goalId, currentAmount);
      }
    }
  }

  void _showAmountExceedDialog(String goalId, double currentAmount) {
    double? tienThua; // Biến lưu trữ số tiền thừa tạm thời
    double? totalAmount;

    // Tìm tổng tiền của mục tiêu tương ứng
    for (var goal in savingsList) {
      if (goal['id'] == goalId) {
        totalAmount = goal['totalAmount'] ?? 0.0;
        break;
      }
    }

    if (totalAmount != null) {
      tienThua = currentAmount - totalAmount;
    }

    // In ra giá trị để kiểm tra
    print(
        'currentAmount: $currentAmount, totalAmount: $totalAmount, tienThua: $tienThua');

    if (tienThua != null && tienThua > 0) {
      print('Số tiền thừa: $tienThua'); // In số tiền thừa ra debug console

      showDialog(
        context: context,
        barrierDismissible:
            false, // Không cho phép đóng dialog khi bấm ngoài vùng hiển thị
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Số tiền đã vượt quá mục tiêu'),
            content: Text(
                'Số tiền thừa là: $tienThua.\nBạn có muốn hủy hoặc chuyển tiền?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng dialog
                  setState(() {
                    ignoredGoalIds.add(goalId);
                    ignoredGoalAmounts[goalId] = currentAmount;
                  });
                  _saveIgnoredGoal(goalId, currentAmount);
                },
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  // Lưu số tiền thừa vào Firestore khi chọn "Chuyển tiền"
                  String? userId =
                      UserStorage.userId; // Lấy User ID từ UserStorage
                  List<Map<String, dynamic>> tienThuaList = [
                    {'goalId': goalId, 'tienThua': tienThua}
                  ];

                  try {
                    await firestoreService.setTienThua(userId!, tienThuaList);
                    print('Lưu tiền thừa thành công!');
                  } catch (e) {
                    print('Lỗi khi lưu tiền thừa: $e');
                  }

                  Navigator.pop(context);
                  // Đóng dialog

                  _showTransferDialog();
                },
                child: const Text('Chuyển tiền'),
              ),
            ],
          );
        },
      );
    } else {
      print('Không có tiền thừa hoặc không đạt điều kiện hiển thị');
    }
  }

  // Hàm xóa mục tiêu tiết kiệm
  Future<void> _deleteSaving(String id) async {
    try {
      await savingService.deleteSaving(id);
      await _loadAllData();
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

// Hiển thị Popup với danh sách sắp xếp
  void _showListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Mục tiêu tiết kiệm',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const Text(
                  'Danh sách mục tiêu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Danh sách mục tiêu
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: savingsList.length,
                    itemBuilder: (context, index) {
                      final goal = savingsList[index];
                      return GestureDetector(
                        onLongPress: () {
                          // Hiển thị dialog khi ấn giữ
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
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
                                          _loadAllData();
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
                        child: SizedBox(
                          height: 100, // Thu nhỏ chiều cao của container
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 3), // Khoảng cách giữa các container
                            padding: const EdgeInsets.all(
                                5), // Padding nhỏ hơn để các mục tiêu gần nhau
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // Loại bỏ viền và shadow
                            ),
                            child: GoalItem(
                                goal: goal), // Hiển thị mục tiêu tiết kiệm
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
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

  void _showTransferDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Mục tiêu tiết kiệm',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const Text(
                  'Danh sách mục tiêu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Danh sách mục tiêu
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: savingsList.length,
                    itemBuilder: (context, index) {
                      final goal = savingsList[index];
                      return SizedBox(
                        height: 100, // Thu nhỏ chiều cao của container
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 3), // Khoảng cách giữa các container
                          padding: const EdgeInsets.all(
                              5), // Padding nhỏ hơn để các mục tiêu gần nhau
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Loại bỏ viền và shadow
                          ),
                          child: GoalItem(
                              goal: goal), // Hiển thị mục tiêu tiết kiệm
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
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
            'Tiết Kiệm',
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
                _loadAllData();
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
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              size: 35,
                            ),
                            onPressed:
                                _showListDialog, // Gọi hàm hiển thị popup
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
                                    backgroundColor: Colors.white,
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
                                              _loadAllData();
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

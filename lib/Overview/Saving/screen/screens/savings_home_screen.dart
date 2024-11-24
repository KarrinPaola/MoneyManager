import 'package:back_up/Overview/Saving/add_goal/goal/add_goals.dart';
import 'package:back_up/Overview/Saving/screen/components/load_data.dart';
import 'package:back_up/Overview/Saving/screen/screens/add_money.dart';
import 'package:back_up/Overview/Saving/screen/widgets/goal_item.dart';
import 'package:back_up/userID_Store.dart';
import 'package:flutter/material.dart';

import '../widgets/savings_widget.dart';

class SavingsHomeScreen extends StatefulWidget {
  const SavingsHomeScreen({super.key});

  @override
  _SavingsHomeScreenState createState() => _SavingsHomeScreenState();
}

class _SavingsHomeScreenState extends State<SavingsHomeScreen> {
  final SavingService savingService = SavingService();
  double totalAmountSum = 0.0;
  double currentAmountSum = 0.0;
  List<Map<String, dynamic>> savingsList = [];

  Future<void> _loadDataTotalAmount() async {
    String? userId = UserStorage.userId;
    double temp = await savingService.getTotalAmount(userId!);
    setState(() {
      totalAmountSum = temp;
    });
  }

  Future<void> _loadDataCurrentAmount() async {
    String? userId = UserStorage.userId;
    double temp = await savingService.getTotalCurrentAmount(userId!);
    setState(() {
      currentAmountSum = temp;
    });
  }

  Future<void> _loadDataSavingList() async {
    String? userId = UserStorage.userId;
    List<Map<String, dynamic>> temp =
        await savingService.getAllSavings(userId!);
    setState(() {
      savingsList = temp;
    });
  }

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
  void initState() {
    super.initState();
    _loadDataTotalAmount();
    _loadDataCurrentAmount();
    _loadDataSavingList();
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
                                            bool? update =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddMoneyScreen(
                                                        goal: goal),
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
                              offset: const Offset(0,
                                  -18), // Di chuyển lên trên 10px (y = -10)
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

import 'package:back_up/Overview/Saving/add_goal/goal/add_goals.dart';
import 'package:back_up/Overview/Saving/screen/components/load_data.dart';
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
      backgroundColor: const Color(0xFFedeff1),
      body: Column(
        children: [
          // Header row with text and icon
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: const Text(
                      'Savings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddGoals(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xFFedeff1),
            padding: EdgeInsets.all(30),
            child: const Center(
              child: SavingsWidget(),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
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
                    child: savingsList.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(25),
                            itemCount: savingsList.length,
                            itemBuilder: (context, index) {
                              return GoalItem(goal: savingsList[index]);
                            },
                          )
                        : const Center(child: Text('No savings available')),
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

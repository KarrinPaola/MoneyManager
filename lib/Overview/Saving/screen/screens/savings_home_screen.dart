import 'package:flutter/material.dart';

import '../widgets/goals_widget.dart';
import '../widgets/savings_widget.dart';
import 'goals_screen.dart';

class SavingsHomeScreen extends StatefulWidget {
  const SavingsHomeScreen({super.key});

  @override
  _SavingsHomeScreenState createState() => _SavingsHomeScreenState();
}

class _SavingsHomeScreenState extends State<SavingsHomeScreen> {
  Future<List<Map<String, dynamic>>> fetchGoals() async {
    // Giả lập việc lấy dữ liệu từ cơ sở dữ liệu
    await Future.delayed(const Duration(seconds: 2));
    return [
      {'name': 'New Bike', 'saved': 300, 'goal': 600},
      {'name': 'Iphone 15 Pro', 'saved': 400, 'goal': 1000},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Savings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.black,
              onPressed: () {
                print('Add new savings');
                // Thêm hành động mở màn hình mới hoặc thực hiện tác vụ
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: SavingsWidget(),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchGoals(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading data"));
                  } else if (snapshot.hasData) {
                    return GoalsWidget(
                      goals: snapshot.data!,
                      onMoreGoalsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GoalsScreen()),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No goals available"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

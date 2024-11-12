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
          'Add Goal',
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
              Title: 'Goal Title',
              hintText: 'Enter your goal',
              isType: true,
              onlyNumber: false,
              controller: goalTitleController,
            ),
            const SizedBox(height: 10),

            // Amount Text Field
            Textfields(
              Title: 'Amount',
              hintText: 'Enter amount',
              isType: true,
              onlyNumber: true,
              controller: amountController,
              iconData: Icons.attach_money,
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
              onPressed: () {
                AddGoalsDatabase(
                    UserStorage.userId!,
                    goalTitleController.text,
                    double.parse(amountController.text),
                    contributionTypeController.text,
                    selectedDay!);
                update = true;
                // Add goal logic here...
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1e42f9),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'ADD GOAL',
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

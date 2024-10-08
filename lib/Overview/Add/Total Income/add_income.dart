import 'package:back_up/Overview/Add/components/process_add_in_out.dart';
import 'package:back_up/Overview/Add/components/process_add_tag_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../Login_SignUp/componets/my_textField.dart';
import '../../../userID_Store.dart';
import '../components/tag_name.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void backToTotalIncome() {
    Navigator.pop(context);
  }

  final titleController = TextEditingController();
  final moneyController = TextEditingController();

  int _selectedTagIndex = -1; // Chỉ số của tag được chọn (khởi tạo là -1)

  String tagNameSelected = "";

  // Hàm xử lý khi tag được nhấn
  void _onTagTap(int index) {
    setState(() {
      _selectedTagIndex = index; // Cập nhật chỉ số tag được chọn
    });
  }

  void _reloadTags() {
    setState(() {});
  }

  Future<List<String>> fetchTagsFromDatabase() async {
    try {
      // Lấy reference của user document từ Firestore
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(UserStorage.userId);

      // Lấy tất cả document trong collection 'tag'
      QuerySnapshot snapshot = await userDocRef.collection('tag').get();

      // Khởi tạo list để chứa các tag
      List<String> tags = [];

      // Duyệt qua các document và lấy giá trị của field 'tag'
      for (var doc in snapshot.docs) {
        tags.add(doc.get('tag') as String);
      }

      // Trả về danh sách tag
      return tags;
    } catch (e) {
      print("Error fetching tags: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi xảy ra
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Add Income',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Thêm border
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chevron_left, color: Colors.black),
                ),
                rightChevronIcon: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Thêm border
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chevron_right, color: Colors.black),
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                dowTextFormatter: (date, locale) {
                  return DateFormat.E(locale).format(date).substring(0, 2);
                },
                weekdayStyle: const TextStyle(color: Colors.black),
                weekendStyle: const TextStyle(color: Colors.red),
              ),
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF1e42f9),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                cellMargin: EdgeInsets.all(7),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Income Title',
                  style: TextStyle(
                    color: Color(0xFF9ba1a8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: 'How you get this money',
            obscureText: false,
            controller: titleController,
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    color: Color(0xFF9ba1a8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: 'How much',
            suffixIcon: CupertinoIcons.money_dollar,
            obscureText: false,
            controller: moneyController,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Income Category',
                  style: TextStyle(
                    color: Color(0xFF9ba1a8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Process_Add_Tag(context, _reloadTags);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      Text("Add Tag"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<String>>(
            future: fetchTagsFromDatabase(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tags found.'));
              }

              List<String> tags = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: List.generate(tags.length, (index) {
                    return TagName(
                      title: tags[index],
                      isSelected: _selectedTagIndex == index,
                      ontap: () {
                        setState(() {
                          _selectedTagIndex = index;
                          tagNameSelected = tags[index];
                          print(tagNameSelected);
                        });
                      },
                    );
                  }),
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 30, top: 20),
        decoration: const BoxDecoration(
            color: Color(0xffffffff),
            border: Border(
              top: BorderSide(
                color: Color(0xFFedeff1),
                width: 1,
              ),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Validate inputs
                if (titleController.text.isNotEmpty &&
                    moneyController.text.isNotEmpty &&
                    _selectedTagIndex != -1 &&
                    UserStorage.userId != null) {
                  // Kiểm tra xem userId có null hay không

                  // Parse money to double
                  double money = double.tryParse(moneyController.text) ?? 0.0;

                  // Call Process_Add_In_Out with all necessary data
                  Process_Add_In_Out(
                      UserStorage
                          .userId!, // Dùng toán tử ! để lấy giá trị String không null
                      titleController.text,
                      money,
                      tagNameSelected,
                      _selectedDay ??
                          DateTime.now(), // Use selected day or current day
                      'income' // Or 'outcome' based on your requirements
                      );

                  backToTotalIncome();
                } else {
                  // Handle validation error (e.g., show a Snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFF1e42f9)),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

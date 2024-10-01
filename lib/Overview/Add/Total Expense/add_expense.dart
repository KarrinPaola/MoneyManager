import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../Login_SignUp/componets/my_textField.dart';
import '../components/tag_name.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void backToTotalExpense() {
    Navigator.pop(context);
  }

  final titleController = TextEditingController();
  final moneyController = TextEditingController();

  int _selectedTagIndex = -1; // Chỉ số của tag được chọn (khởi tạo là -1)

  // Hàm xử lý khi tag được nhấn
  void _onTagTap(int index) {
    setState(() {
      _selectedTagIndex = index; // Cập nhật chỉ số tag được chọn
    });
  }

  Future<List<String>> fetchTagsFromDatabase() async {
    // Trả về danh sách tag
    return [ 'Salary', 'Rewards', 'Money extra', 'Food', 'Go'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFedeff1),
      appBar: AppBar(
      
        backgroundColor: Color(0xffffffff),
        title: Text('Add Expense', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
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
                  child: Icon(Icons.chevron_left, color: Colors.black),
                ),
                rightChevronIcon: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Thêm border
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.chevron_right, color: Colors.black),
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                dowTextFormatter: (date, locale) {
                  return DateFormat.E(locale).format(date).substring(0, 2);
                },
                weekdayStyle: TextStyle(color: Colors.black),
                weekendStyle: TextStyle(color: Colors.red),
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
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Expense Title',
                  style: TextStyle(
                    color: Color(0xFF9ba1a8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: 'What need your money?',
            obscureText: false,
            controller: titleController,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
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
          SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: 'How much',
            suffixIcon: CupertinoIcons.money_dollar,
            obscureText: false,
            controller: moneyController,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Expense Category',
                  style: TextStyle(
                    color: Color(0xFF9ba1a8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<List<String>>(
            future: fetchTagsFromDatabase(), // Gọi hàm lấy tag
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasError) {
                // Hiển thị thông báo lỗi nếu có
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Kiểm tra nếu không có tag nào được trả về
                return const Center(child: Text('No tags found.'));
              }

              // Lấy danh sách tag từ snapshot
              List<String> tags = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: List.generate(tags.length, (index) {
                    return TagName(
                      title: tags[index],
                      isSelected: _selectedTagIndex == index, // Chỉ định trạng thái selected
                      ontap: () => _onTagTap(index), // Xử lý khi nhấn vào tag
                    );
                  }),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

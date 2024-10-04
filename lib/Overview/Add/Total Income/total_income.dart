
import 'package:back_up/Overview/Add/Total%20Income/add_income.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class TotalIncome extends StatefulWidget {
  const TotalIncome({super.key});

  @override
  State<TotalIncome> createState() => _TotalIncomeState();
}

class _TotalIncomeState extends State<TotalIncome> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Data for different days' spends
  final Map<String, List<Map<String, String>>> _spendsData = {
    '2024-10-01': [
      {'title': 'Food', 'amount': '+ \$20 + VAT 0.5%', 'method': 'Google Pay'},
      {'title': 'Coffee', 'amount': '+ \$5 + Vat 0.2%', 'method': 'Cash'},
      {'title': 'Coffee', 'amount': '+ \$5 + Vat 0.2%', 'method': 'Cash'},
      {'title': 'Coffee', 'amount': '+ \$5 + Vat 0.2%', 'method': 'Cash'},
      {'title': 'Uber', 'amount': '- \$18 + VAT 0.8%', 'method': 'Cash'},
    ],
    '2024-03-13': [
      {'title': 'Uber', 'amount': '- \$18 + VAT 0.8%', 'method': 'Cash'},
    ],
    '2024-03-11': [
      {'title': 'Shopping', 'amount': '- \$400 + VAT 0.12%', 'method': 'Paytm'},
    ],
  };

  List<Map<String, String>> _spendItems = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadSpendsForDay(_selectedDay!);
  }

  // Method to load spends for the selected day
  void _loadSpendsForDay(DateTime day) {
    final dayKey = DateFormat('yyyy-MM-dd').format(day);
    setState(() {
      _spendItems = _spendsData[dayKey] ?? [];
    });
  }

  void goToAddExpense() {
    print("Navigating to Total Expense");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddIncome()),
    );
  }

  void backToOverview() {
    Navigator.pop(context);
  }

  double _loadTotalExpense() {
    return 1600;
  }

  double _loadPercent() {
    return 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFedeff1),
        appBar: AppBar(
          backgroundColor: const Color(0xffffffff),
          title: const Text('Total Income'),
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
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: const Color(0xFF1e42f9)),
              child: Text(
                '\$${_loadTotalExpense()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'You try so hard to make this money.\n Keep going!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xff000000),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      // Tab Bar
                      const TabBar(
                        labelColor: Color(0xFF1e42f9),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color(0xFF1e42f9),
                        tabs: [
                          Tab(text: 'Spends'),
                          Tab(text: 'Categories'),
                        ],
                      ),
                      // Expanded to ensure the TabBarView takes the remaining space
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Spends Tab with a ListView
                            _spendItems.isNotEmpty
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _spendItems.length,
                                    itemBuilder: (context, index) {
                                      return buildSpendItem(
                                        _spendItems[index]['title'] ?? '',
                                        DateFormat('dd MMM yyyy')
                                            .format(_selectedDay!),
                                        _spendItems[index]['amount'] ?? '',
                                        _spendItems[index]['method'] ?? '',
                                      );
                                    },
                                  )
                                : const Center(child: Text('No spends for this day')),
                            // Categories Tab (Placeholder)
                            const Center(child: Text('No Categories available')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
              ))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: goToAddExpense,
                child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 015),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFF1e42f9)),
                  child: const Text(
                    "Add Income",
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
        )
      );
  }

  Widget buildSpendItem(
      String title, String date, String amount, String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.shopping_bag, color: Color(0xFF000000)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(method, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

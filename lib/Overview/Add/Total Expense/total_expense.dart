import 'package:back_up/check_fetch_data.dart';

import 'package:back_up/userID_Store.dart';

import 'package:back_up/Overview/Add/Total%20Expense/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../components/items.dart';
import '../components/load_data.dart';
import '../components/pie_chart_with_map.dart';

class TotalExpense extends StatefulWidget {
  const TotalExpense({super.key});

  @override
  State<TotalExpense> createState() => _TotalExpenseState();
}

class _TotalExpenseState extends State<TotalExpense> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Service _service = Service();
  double _totalExpense = 0;
  List<Map<String, String>> _expenseItems = [];
  bool updateTotal = false;
  Map<String, double> outcomeByTag = {};

  Future<void> _loadTotalExpense() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    double total = await _service.fetchDataForMonth(
      userId,
      _selectedDay!,
      'outcome',
    );

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _totalExpense = total;
      totalExpenseGL = _totalExpense;
    });
  }

  Future<void> _loadExpense() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    List<Map<String, String>> expenseItemLoad = await _service.fetchDataForDay(
      userId,
      _selectedDay!,
      'outcome',
    );

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _expenseItems = expenseItemLoad;
    });
  }

  Future<void> _loadDataOrderByTag() async {
    String? userId = UserStorage.userId;
    Map<String, double> itemLoaded = await _service.fetchMonthlyIncomeByTag(
        userId!, _selectedDay!, 'tagOutcome', 'outcome');
    setState(() {
      outcomeByTag = itemLoaded;
    });
  }

  void backToHome() {
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadExpense(); // Lấy dữ liệu thu nhập cho ngày hiện tại
    _totalExpense = totalExpenseGL;
    _loadDataOrderByTag();
  }

  // Phương thức để load thu nhập cho ngày đã chọn
  void _loadExpensesForDay(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
    _loadExpense();
    _loadDataOrderByTag();
  }

  void goToAddExpense() async {
    final update = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpense()),
    );
    if (update == true) {
      // Gọi lại các phương thức để cập nhật lại dữ liệu thu nhập
      setState(() {
        _loadExpense();
        _loadTotalExpense();
        updateTotal = update;
        _loadDataOrderByTag();
      });
    }
  }

  // Định dạng hiển thị số kiểu VN

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff1),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        title: const Text(
          'Tổng chi phí',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Thay mũi tên bằng một icon khác
          onPressed: () {
            // Hành động khi nhấn vào icon
            backToHome();
          },
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
              locale: 'vi_VN',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                _loadExpensesForDay(
                    selectedDay); // Tải thu nhập cho ngày đã chọn
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.black),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
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
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: const Color(0xFF1e42f9),
            ),
            child: Text(
              _service.formatCurrency(_totalExpense), // Hiển thị tổng thu nhập
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hãy cẩn thận với chi tiêu của mình!\nKhông cuối tháng trở thành địa ngục đó nha :)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF1e42f9),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF1e42f9),
                      tabs: [
                        Tab(text: 'Chi phí'),
                        Tab(text: 'Phân loại'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab Expenses với ListView
                          _expenseItems.isNotEmpty
                              ? ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _expenseItems.length,
                                  itemBuilder: (context, index) {
                                    return buildItem(
                                      _expenseItems[index]['title'] ?? '',
                                      DateFormat('dd MMM yyyy')
                                          .format(_selectedDay!),
                                      _expenseItems[index]['amount'] ?? '',
                                      _expenseItems[index]['tag'] ?? '',
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                      'Không có khoản chi nào trong hôm nay')),
                          // Tab Categories (Chưa có nội dung)
                          ListView(children: [
                            Center(
                                child:
                                    PieChartWithMap(incomeByTag: outcomeByTag)),
                          ]),
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
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: goToAddExpense,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFF1e42f9),
                ),
                child: const Text(
                  "Thêm khoản chi",
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

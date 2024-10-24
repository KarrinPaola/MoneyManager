import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../check_fetch_data.dart';
import '../../../userID_Store.dart';
import '../components/items.dart';
import '../components/load_data.dart';
import '../components/pie_chart_with_map.dart';
import 'add_income.dart';

class TotalIncome extends StatefulWidget {
  const TotalIncome({super.key});

  @override
  State<TotalIncome> createState() => _TotalIncomeState();
}

class _TotalIncomeState extends State<TotalIncome> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Service _service = Service();
  double _totalIncome = 0;
  List<Map<String, String>> _incomeItems = [];
  bool updateTotal = false;
  Map<String, double> incomeByTag = {};
  Map<String, String> incomeByTagTotal = {};

  Future<void> _loadTotalIncome() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    double total = await _service.fetchDataForMonth(
      userId,
      _selectedDay!,
      'income',
    );

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _totalIncome = total;
      totalIncomeGL = _totalIncome;
    });
  }

  Future<void> _loadIncome() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    List<Map<String, String>> incomeItemLoad = await _service.fetchDataForDay(
      userId,
      _selectedDay!,
      'income',
    );

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _incomeItems = incomeItemLoad;
    });
  }

  Future<void> _loadDataOrderByTag() async {
    String? userId = UserStorage.userId;
    Map<String, double> itemLoaded = await _service.fetchMonthlyIncomeByTag(
        userId!, _selectedDay!, 'tagIncome', 'income');
    setState(() {
      incomeByTag = itemLoaded;
    });
  }

  Future<void> _loadDataOrderByTagToTal() async {
    String? userId = UserStorage.userId;
    Map<String, String> itemLoaded =
        await _service.fetchMonthlyIncomeByTagTotal(
            userId!, _selectedDay!, 'tagIncome', 'income');
    setState(() {
      incomeByTagTotal = itemLoaded;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadIncome(); // Lấy dữ liệu thu nhập cho ngày hiện tại
    _totalIncome = totalIncomeGL;
    _loadDataOrderByTag();
    _loadDataOrderByTagToTal();
  }

  // Phương thức để load thu nhập cho ngày đã chọn
  void _loadIncomesForDay(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
    _loadIncome();
    _loadDataOrderByTag();
    _loadDataOrderByTagToTal();
  }

  void backToHome() {
    Navigator.pop(context, true);
  }

  void goToAddIncome() async {
    final update = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddIncome()),
    );
    if (update == true) {
      // Gọi lại các phương thức để cập nhật lại dữ liệu thu nhập
      setState(() {
        _loadIncome();
        _loadTotalIncome();
        updateTotal = update;
        _loadDataOrderByTag();
        _loadDataOrderByTagToTal();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff1),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        title: const Text(
          'Tổng ngân sách',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Thay mũi tên bằng một icon khác
          onPressed: () {
            // Hành động khi nhấn vào icon
            backToHome();
            print("Quay về home");
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
                _loadIncomesForDay(
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
              _service.formatCurrency(_totalIncome), // Hiển thị tổng thu nhập
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Bạn đã cố gắng rất nhiều để có số tiền này.\n Cố lên nào!',
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
                        Tab(text: 'Thu nhập'),
                        Tab(text: 'Phân loại'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab Incomes với ListView
                          _incomeItems.isNotEmpty
                              ? ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _incomeItems.length,
                                  itemBuilder: (context, index) {
                                    return ItemWidget(
                                      title: _incomeItems[index]['title'] ?? '',
                                      date: DateFormat('dd/MM/yyyy')
                                          .format(_selectedDay!),
                                      amount:
                                          _incomeItems[index]['amount'] ?? '',
                                      tagName: _incomeItems[index]['tag'] ?? '',
                                      onDelete: () {
                                        _service.deleteItemWidget(
                                            UserStorage.userId!,
                                            'income',
                                            _incomeItems[index]['id'] ?? '');
                                        _loadIncome(); // Lấy dữ liệu thu nhập cho ngày hiện tại
                                        _totalIncome = totalIncomeGL;
                                        _loadDataOrderByTag();
                                        _loadDataOrderByTagToTal();
                                        _loadTotalIncome();
                                      },
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                      'Không có khoản thu nào trong hôm nay')),
                          // Tab Categories (Chưa có nội dung)
                          Center(
                              child: PieChartWithMap(
                            incomeByTag: incomeByTag,
                            totalAmountByTag: incomeByTagTotal,
                          )),
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
              onTap: goToAddIncome,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFF1e42f9),
                ),
                child: const Text(
                  "Thêm ngân sách",
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

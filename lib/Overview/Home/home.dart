import 'package:back_up/userID_Store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Add/Total Expense/total_expense.dart';
import '../Add/Total Income/total_income.dart';
import '../Add/components/load_data.dart';
import 'components/customButton.dart';
import 'components/customTaskView.dart';
import 'components/walletTag.dart';

class OverviewHome extends StatefulWidget {
  const OverviewHome({super.key});

  @override
  State<OverviewHome> createState() => _OverviewHomeState();
}

class _OverviewHomeState extends State<OverviewHome> {
  //Return email
  final user = FirebaseAuth.instance.currentUser;
  final Service _service = Service();
  double _totalIncome = 0;
  double _totalExpense = 0;
  List<Map<String, String>> _incomeItems = [];
  List<Map<String, String>> _expenseItems = [];
  List<Map<String, String>> _remindItems = [];

  List<Map<String, String>> getSelectedItems(int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      return _expenseItems;
    case 1:
      return _remindItems;  // Remind items
    case 2:
      return _incomeItems;
    default:
      return [];
  }
}

  Future<void> _loadTotalIncome() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    double total =
        await _service.fetchDataForMonth(userId, DateTime.now(), 'income');

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _totalIncome = total;
    });
  }

  Future<void> _loadTotalExpense() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    double total =
        await _service.fetchDataForMonth(userId, DateTime.now(), 'outcome');

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _totalExpense = total;
    });
  }

  Future<void> _loadIncome() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    List<Map<String, String>> incomeItemLoad =
        await _service.fetchDataForMonthEachDay(userId, DateTime.now(), 'income');

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _incomeItems = incomeItemLoad;
    });
  }

  Future<void> _loadExpense() async {
    String? userId = UserStorage.userId; // Lấy userId nếu cần
    List<Map<String, String>> expenseItemLoad =
        await _service.fetchDataForMonthEachDay(userId, DateTime.now(), 'outcome');

    // Cập nhật state để hiển thị tổng thu nhập mới
    setState(() {
      _expenseItems = expenseItemLoad;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTotalIncome(); // Gọi hàm load total income
    _loadTotalExpense(); // Gọi hàm load total expense
    _loadExpense();
    _loadIncome();
  }

  //Xử lý phần view 2
  int selectedIndex = 0;
  void _onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  int selectedWalletTag = 0;
  void _onWalletPressed(int index) {
    setState(() {
      selectedWalletTag = index;
    });
  }

  // Xử lý sign - out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    UserStorage.userId = "";
  }

  void goToTotalExpense() {
    print("Navigating to Total Expense");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TotalExpense()),
    );
  }

  void goToTotalIncome() {
    print("Navigating to Total Expense");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TotalIncome()),
    );
  }


  // Dữ liệu mẫu cho các danh sách
  final List<List<Map<String, String>>> lists = [
    [
      {
        "title": "Food",
        "date": "20 Feb 2024",
        "amount": "+ \$20 + Vat 0.5%",
        "payment": "Google Pay"
      },
      {
        "title": "Uber",
        "date": "13 Mar 2024",
        "amount": "- \$18 + Vat 0.8%",
        "payment": "Cash"
      },
      {
        "title": "Shopping",
        "date": "11 Mar 2024",
        "amount": "- \$400 + Vat 0.12%",
        "payment": "Paytm"
      },
    ],
    [
      {
        "title": "Water Bill",
        "date": "10 Jan 2024",
        "amount": "- \$50",
        "payment": "Credit Card"
      },
      {
        "title": "Electricity",
        "date": "25 Jan 2024",
        "amount": "- \$100",
        "payment": "Direct Debit"
      },
    ],
    [
      {
        "title": "Income",
        "date": "01 Mar 2024",
        "amount": "+ \$1000",
        "payment": "Bank Transfer"
      },
      {
        "title": "Bonus",
        "date": "05 Mar 2024",
        "amount": "+ \$500",
        "payment": "Bank Transfer"
      },
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF000000)),
                    ),
                    GestureDetector(
                      onTap: signUserOut,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFF9ba1a8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 220,
            color: const Color(0xFFedeff1),
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                WalletTag(
                  title: 'Total Income',
                  money: _service.formatCurrency(_totalIncome),
                  onTap: goToTotalIncome,
                  leftMargin: true,
                  rightMargin: false,
                  index: 1,
                  onTap2: _onWalletPressed,
                  selectedWalletTag: selectedWalletTag,
                ),
                WalletTag(
                  title: 'Total Expense',
                  money: _service.formatCurrency(_totalExpense),
                  onTap: goToTotalExpense,
                  leftMargin: false,
                  rightMargin: false,
                  index: 2,
                  onTap2: _onWalletPressed,
                  selectedWalletTag: selectedWalletTag,
                ),
                WalletTag(
                  title: 'Total Monthly',
                  money: _service.formatCurrency(_totalIncome - _totalExpense),
                  onTap: () {},
                  leftMargin: false,
                  rightMargin: true,
                  index: 3,
                  onTap2: _onWalletPressed,
                  selectedWalletTag: selectedWalletTag,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height / 1.95,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), // Bo tròn góc trên bên trái
                  topRight:
                      Radius.circular(30), // Không bo tròn góc trên bên phải
                  bottomLeft:
                      Radius.circular(0), // Không bo tròn góc dưới bên trái
                  bottomRight: Radius.circular(0),
                )),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Custombutton(
                      title: 'Expenses',
                      onTap: _onButtonPressed, // Pass the callback
                      iconData: Icons.savings,
                      index: 0, // Assign an index to each button
                      selectedIndex: selectedIndex,
                    ),
                    Custombutton(
                      title: 'Reminds',
                      onTap: _onButtonPressed,
                      iconData: Icons.notification_important,
                      index: 1,
                      selectedIndex: selectedIndex,
                    ),
                    Custombutton(
                      title: 'Budgets',
                      onTap: _onButtonPressed,
                      iconData: Icons.wallet,
                      index: 2,
                      selectedIndex: selectedIndex,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTaskView(index: 0, selectedIndex: selectedIndex),
                    CustomTaskView(index: 1, selectedIndex: selectedIndex),
                    CustomTaskView(index: 2, selectedIndex: selectedIndex)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Latest Entitries',
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
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(
                            Icons.more_horiz,
                            size: 35,
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: getSelectedItems(selectedIndex).length,
                    itemBuilder: (context, index) {
                      final entry = getSelectedItems(selectedIndex)[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.monetization_on,
                          color: Color(0xFF000000),
                        ),
                        title: Text(
                          entry['title']!,
                          style: const TextStyle(
                              color: Color(
                                0xFF000000,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        subtitle: Text(
                          entry['date']!,
                          style: const TextStyle(
                            color: Color(0xFF9ba1a8),
                            fontSize: 13,
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(entry['amount']!,
                                  style: const TextStyle(
                                      color: Color(0xFF000000))),
                              Text(entry['tag']!,
                                  style: const TextStyle(
                                      color: Color(0xFF9ba1a8))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

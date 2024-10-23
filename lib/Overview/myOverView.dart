import 'dart:ui';

import 'package:back_up/Overview/Saving/screen/saving_homescreens.dart';
import 'package:flutter/material.dart';

import 'Add/Total Expense/add_expense.dart';
import 'Add/Total Income/add_income.dart';
import 'Home/home.dart';
import 'Notification/notification.dart';
import 'Set Reminder/ser_reminder.dart';
import 'button_add.dart';

class MyOverview extends StatefulWidget {
  const MyOverview({super.key});

  @override
  State<MyOverview> createState() => _MyOverviewState();
}

class _MyOverviewState extends State<MyOverview> {
  int _selectedTab = 0;
  bool _isMenuVisible = false;

  static final List<Widget> _widgetList = <Widget>[
    const OverviewHome(),
    const SavingHomescreens(),
    const OverviewNotification(),
    const OverviewSetReminder()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: _selectedTab,
            children: _widgetList,
          ),
          bottomNavigationBar: Container(
            padding:
                const EdgeInsets.only(bottom: 30, top: 20, right: 10, left: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(
                top: BorderSide(
                  color: Color(0xFFedeff1),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => _onItemTapped(0),
                  icon: Icon(Icons.home,
                      color: _selectedTab == 0
                          ? const Color(0xFF1e42f9)
                          : const Color(0xFF9ba1a8)),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () => _onItemTapped(1),
                  icon: Icon(Icons.savings,
                      color: _selectedTab == 1
                          ? const Color(0xFF1e42f9)
                          : const Color(0xFF9ba1a8)),
                  iconSize: 30,
                ),
                const SizedBox(
                  width: 25,
                ),
                IconButton(
                  onPressed: () => _onItemTapped(2),
                  icon: Icon(Icons.notification_important,
                      color: _selectedTab == 2
                          ? const Color(0xFF1e42f9)
                          : const Color(0xFF9ba1a8)),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () => _onItemTapped(3),
                  icon: Icon(Icons.settings,
                      color: _selectedTab == 3
                          ? const Color(0xFF1e42f9)
                          : const Color(0xFF9ba1a8)),
                  iconSize: 30,
                ),
              ],
            ),
          ),
          floatingActionButton: _isMenuVisible
              ? null
              : SizedBox(
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isMenuVisible = true;
                      });
                    },
                    backgroundColor: const Color(0xFF1e42f9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
        if (_isMenuVisible)
          GestureDetector(
            onTap: () {

              setState(() {
                _isMenuVisible = false;
                _selectedTab = 0; // Ẩn menu khi bấm ra ngoài
              });
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: double
                    .infinity, // Đảm bảo Container bao phủ toàn bộ chiều rộng
                height: double
                    .infinity, // Đảm bảo Container bao phủ toàn bộ chiều cao
                color: Colors.grey.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Để các button ở giữa màn hình
                  children: [
                    ButtonAdd(
                        title: "Add Income",
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddIncome()),
                          );
                        }),
                    ButtonAdd(
                        title: "Add Expense",
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddExpense()),
                          );
                        }),
                    const SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}

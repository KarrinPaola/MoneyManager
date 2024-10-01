import 'package:flutter/material.dart';

import 'Home/home.dart';
import 'Notification/notification.dart';
import 'Saving/saving.dart';
import 'Set Reminder/ser_reminder.dart';

class MyOverview extends StatefulWidget {
  const MyOverview({super.key});

  @override
  State<MyOverview> createState() => _MyOverviewState();
}

class _MyOverviewState extends State<MyOverview> {
  int _selectedTab = 0;

  static const List<Widget> _widgetList = <Widget>[
    OverviewHome(),
    OverviewSaving(),
    OverviewNotification(),
    OverviewSetReminder()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: _widgetList,
      ),
      bottomNavigationBar: Container(
        padding:const EdgeInsets.only(bottom: 30, top: 20, right: 10, left: 10),
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
              icon: Icon(
                Icons.home,
                color: _selectedTab == 0
                    ? const Color(0xFF1e42f9)
                    : const Color(0xFF9ba1a8)
              ),
              iconSize: 30,
            ),
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: Icon(
                Icons.savings,
                color: _selectedTab == 1
                    ? const Color(0xFF1e42f9)
                    : const Color(0xFF9ba1a8)
              ),
              iconSize: 30,
            ),
            const SizedBox(
              width: 25,
            ),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: Icon(
                Icons.notification_important,
                color: _selectedTab == 2
                    ? const Color(0xFF1e42f9)
                    : const Color(0xFF9ba1a8)
              ),
              iconSize: 30,
            ),
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: Icon(
                Icons.settings,
                color: _selectedTab == 3
                    ? const Color(0xFF1e42f9)
                    : const Color(0xFF9ba1a8)
              ),
              iconSize: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF1e42f9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

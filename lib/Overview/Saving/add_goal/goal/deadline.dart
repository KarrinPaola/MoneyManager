import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DeadlineLogic {
  DateTime? selectedDate;
  CalendarFormat calendarFormat = CalendarFormat.month;

  // Hàm để hiển thị bảng chọn ngày qua dialog
  Future<void> selectDate(BuildContext context, Function(DateTime?) onSelected) async {
    // Đặt focusedDay thành ngày hiện tại hoặc ngày đã chọn trước đó
    DateTime focusedDay = selectedDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(15.0),
            width: 400, // Đặt chiều rộng của dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar(
                  focusedDay: focusedDay,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  calendarFormat: calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    this.selectedDate = selectedDay;  // Cập nhật ngày đã chọn
                    onSelected(selectedDay);            // Gọi hàm callback với ngày đã chọn
                    Navigator.pop(context); // Đóng dialog sau khi chọn ngày
                  },
                  selectedDayPredicate: (day) {
                    // Xác định ngày đã chọn
                    return isSameDay(selectedDate, day);
                  },
                  calendarBuilders: CalendarBuilders(
                    // Định dạng cho ngày hiện tại
                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue, // Màu nền cho ngày hiện tại
                          shape: BoxShape.circle,
                        ),
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: Colors.white, // Màu chữ cho ngày hiện tại
                          ),
                        ),
                      );
                    },
                    // Định dạng cho ngày đã chọn
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey, // Màu nền cho ngày đã chọn
                          shape: BoxShape.circle,
                        ),
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: Colors.white, // Màu chữ cho ngày đã chọn
                          ),
                        ),
                      );
                    },
                  ),
                  currentDay: DateTime.now(),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Tháng',
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

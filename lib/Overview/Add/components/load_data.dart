import 'package:back_up/userID_Store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Service {
  // Hàm để lấy tổng thu nhập cho tháng được chỉ định
  Future<double> fetchDataForMonth(
      String? userId, DateTime date, String tableName) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    print('Fetching income data for month: ${date.month}/${date.year}');

    try {
      // Xác định ngày bắt đầu và kết thúc của tháng hiện tại
      DateTime startDate = DateTime(date.year, date.month, 1, 0, 0, 0);
      DateTime endDate = DateTime(
          date.year, date.month + 1, 0, 23, 59, 59); // Ngày cuối cùng của tháng

      QuerySnapshot dataSnapshot = await userDocRef
          .collection(tableName)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      List<Map<String, String>> data = [];
      double totalIncome = 0; // Khởi tạo biến tổng thu nhập

      for (var doc in dataSnapshot.docs) {
        double amount =
            (doc['amount'] as num).toDouble(); // Chuyển đổi sang double
        data.add({
          'title': doc['title'],
          'amount':
              formatCurrency(amount), // Sử dụng _formatCurrency để định dạng
          'tag': doc['tag'], // Bao gồm tag nếu cần
        });
        totalIncome += amount; // Cộng dồn vào tổng thu nhập
      }
      // Bạn có thể trả về danh sách data nếu cần
      return totalIncome; // Trả về tổng thu nhập
    } catch (e) {
      print('Error fetching income data: $e');
      return 0; // Trả về 0 trong trường hợp có lỗi
    }
  }

  // Phương thức để lấy dữ liệu cho ngày đã chọn
  Future<List<Map<String, String>>> fetchDataForDay(
      String? userId, DateTime date, String tableName) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    print('Fetching $tableName data for date: $date');

    List<Map<String, String>> data = [];

    try {
      DateTime startDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
      DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot dataSnapshot = await userDocRef
          .collection(tableName)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      for (var doc in dataSnapshot.docs) {
        data.add({
          'title': doc['title'],
          'amount': formatCurrency(
              (doc['amount'] as num).toDouble()), // Định dạng thu nhập
          'tag': doc['tag'], // Bao gồm tag nếu cần
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return data;
  }


Future<List<Map<String, String>>> fetchDataForMonthEachDay(
    String? userId, DateTime date, String tableName) async {
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
  print('Fetching $tableName data for month: ${date.month}/${date.year}');

  List<Map<String, String>> data = [];

  try {
    // Lấy ngày đầu tiên và ngày cuối cùng của tháng
    DateTime startDate = DateTime(date.year, date.month, 1, 0, 0, 0);
    DateTime endDate = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

    QuerySnapshot dataSnapshot = await userDocRef
        .collection(tableName)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    // Định dạng ngày
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    for (var doc in dataSnapshot.docs) {
      // Lấy timestamp từ Firestore và chuyển thành DateTime
      Timestamp timestamp = doc['date'];
      DateTime docDate = timestamp.toDate();

      data.add({
        'title': doc['title'],
        'amount': formatCurrency((doc['amount'] as num).toDouble()), // Định dạng thu nhập
        'tag': doc['tag'],
        'date': dateFormat.format(docDate), // Định dạng ngày thành dd/MM/yyyy
      });
    }
  } catch (e) {
    print('Error fetching data: $e');
  }

  return data;
}

  // Hàm định dạng số tiền thành chuỗi tiền tệ Việt Nam Đồng
  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatCurrency.format(amount);
  }

  
}

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
        data.insert(0, {
          'id': doc.id, // Thêm ID của document
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
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
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

        data.insert(0, {
          'id': doc.id, // Thêm ID của document
          'title': doc['title'],
          'amount': formatCurrency(
              (doc['amount'] as num).toDouble()), // Định dạng thu nhập
          'tag': doc['tag'],
          'date': dateFormat.format(docDate), // Định dạng ngày thành dd/MM/yyyy
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return data;
  }

  Future<Map<String, double>> fetchMonthlyIncomeByTag(
      String userId,
      DateTime selectedDate,
      String tagCollection,
      String incomeCollection) async {
    final startDate =
        DateTime(selectedDate.year, selectedDate.month, 1); // Ngày đầu tháng
    final endDate = DateTime(
        selectedDate.year, selectedDate.month + 1, 1); // Ngày đầu tháng sau

    // Lấy income cho tháng được chỉ định
    final incomeSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(incomeCollection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThan: Timestamp.fromDate(endDate))
        .get();

    // Lấy tagIncome
    final tagSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(tagCollection)
        .get();

    Map<String, double> incomeByTag = {};
    double totalIncome = 0.0;

    // Tạo danh sách các tag
    List<String> tags =
        tagSnapshot.docs.map((doc) => doc['tag'] as String).toList();

    // Tính tổng thu nhập cho từng tag và tổng thu nhập
    for (var doc in incomeSnapshot.docs) {
      final data = doc.data();
      final tag = data['tag'] ?? 'unknown'; // Tag từ income
      final amount = (data['amount'] as num).toDouble();

      // Cộng dồn tổng thu nhập
      totalIncome += amount;

      // Nếu tag đã tồn tại trong danh sách tag hoặc income
      if (tags.contains(tag) || incomeByTag.containsKey(tag)) {
        if (incomeByTag.containsKey(tag)) {
          incomeByTag[tag] = incomeByTag[tag]! + amount;
        } else {
          incomeByTag[tag] = amount;
        }
      } else {
        // Nếu tag không có trong tags, thêm nó vào incomeByTag
        incomeByTag[tag] = (incomeByTag[tag] ?? 0) + amount;
      }
    }

    // Tính phần trăm cho từng tag
    Map<String, double> incomePercentageByTag = {};
    if (totalIncome > 0) {
      incomeByTag.forEach((tag, amount) {
        incomePercentageByTag[tag] =
            (amount / totalIncome) * 100; // Tính phần trăm
      });
    }

    return incomePercentageByTag;
  }

  Future<Map<String, String>> fetchMonthlyIncomeByTagTotal(
      String userId,
      DateTime selectedDate,
      String tagCollection,
      String moneyCollection) async {
    final startDate =
        DateTime(selectedDate.year, selectedDate.month, 1); // Ngày đầu tháng
    final endDate = DateTime(
        selectedDate.year, selectedDate.month + 1, 1); // Ngày đầu tháng sau

    // Lấy income cho tháng được chỉ định
    final moneySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(moneyCollection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThan: Timestamp.fromDate(endDate))
        .get();

    // Lấy tagIncome
    final tagSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(tagCollection)
        .get();

    Map<String, double> moneyByTag = {};

    // Tạo danh sách các tag từ collection tag
    List<String> tags =
        tagSnapshot.docs.map((doc) => doc['tag'] as String).toList();

    // Tính tổng thu nhập cho từng tag
    for (var doc in moneySnapshot.docs) {
      final data = doc.data();
      final tag = data['tag'] ?? 'unknown'; // Tag từ money
      final amount = (data['amount'] as num).toDouble();

      // Nếu tag đã tồn tại trong danh sách tag hoặc moneyByTag
      if (tags.contains(tag) || moneyByTag.containsKey(tag)) {
        if (moneyByTag.containsKey(tag)) {
          moneyByTag[tag] = moneyByTag[tag]! + amount;
        } else {
          moneyByTag[tag] = amount;
        }
      } else {
        // Nếu tag không có trong tags, thêm nó vào moneyByTag
        moneyByTag[tag] = (moneyByTag[tag] ?? 0) + amount;
      }
    }

    // Chuyển đổi kết quả sang Map<String, String>
    Map<String, String> incomeMap = moneyByTag.map(
      (key, value) => MapEntry(key, formatCurrency(value)),
    );

    return incomeMap;
  }

  Future<void> deleteTag(
      String? userId, String tagId, String tagCollection) async {
    // Tham chiếu đến document của user
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Tham chiếu đến collection tag phù hợp
    final tagCollectionRef = userDocRef.collection(tagCollection);

    // Tham chiếu đến document tag cần xóa
    final tagDocRef = tagCollectionRef.doc(tagId);

    try {
      // Xóa document tag
      await tagDocRef.delete();
      print('Tag deleted successfully');
    } catch (e) {
      print('Error deleting tag: $e');
    }
  }

  Future<void> deleteItemWidget(
      String userId, String tableName, String itemId) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Xóa document từ sub-collection
      await userDocRef.collection(tableName).doc(itemId).delete();
      print('Item $itemId deleted successfully from $tableName.');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  // Hàm định dạng số tiền thành chuỗi tiền tệ Việt Nam Đồng
  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatCurrency.format(amount);
  }
}

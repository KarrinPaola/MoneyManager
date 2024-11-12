import 'package:back_up/check_fetch_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> AddGoalsDatabase(
  String userId,
  String title,
  double totalAmount,
  String type,
  DateTime dateTime,
) async {
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    // Đặt document cho income hoặc outcome tùy thuộc vào biến 'in'

    // Nếu in là true, thêm vào collection income
    await userDocRef.collection('saving').add({
      'title': title,
      'currentAmount': 0,
      'totalAmount': totalAmount,
      'type': type,
      'date': Timestamp.fromDate(dateTime), // Lưu cả ngày giờ
    });
    needToFetch = true;
    print('Income added successfully');
  } catch (e) {
    print('Error adding income/outcome: $e');
  }

  Future<double> getTotalCurrentAmount(String userId) async {
    double currentAmountSum = 0.0;

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final QuerySnapshot snapshot =
          await userDocRef.collection('saving').get();

      for (var doc in snapshot.docs) {
        currentAmountSum += doc['currentAmount'];
      }

      print('Total current amount: $currentAmountSum');
    } catch (e) {
      print('Error fetching current amount: $e');
      return 0.0; // Return 0 in case of an error
    }

    return currentAmountSum;
  }
}

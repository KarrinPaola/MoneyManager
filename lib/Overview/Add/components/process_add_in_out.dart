import 'package:back_up/check_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> Process_Add_In_Out(String userId, String title, double money,
    String tag, DateTime dateTime, String tableType) async {
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    // Đặt document cho income hoặc outcome tùy thuộc vào biến 'in'

    // Nếu in là true, thêm vào collection income
    await userDocRef.collection(tableType).add({
      'title': title,
      'amount': money,
      'tag': tag,
      'date': Timestamp.fromDate(dateTime), // Lưu cả ngày giờ
    });
    print('Income added successfully');
  } catch (e) {
    print('Error adding income/outcome: $e');
  }
}

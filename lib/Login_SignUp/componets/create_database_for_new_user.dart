import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createUserDatabase(String userId, String? email) async {
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    // Lấy ngày hiện tại nhưng đặt thời gian thành 00:00:00
    final currentDate = DateTime.now();
    final onlyDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Tạo document user với một vài trường cơ bản
    await userDocRef.set({
      'createdAt': Timestamp.fromDate(onlyDate),
      'userId': userId,
      'email': email,
      'totalIncome': 0, // Khởi tạo totalIncome
      'totalOutcome': 0, // Khởi tạo totalOutcome
    });

    // Tạo sub-collection income
    await userDocRef.collection('income').doc('sampleIncome').set({
      'title': 'Sample Income',
      'amount': 0,
      'tag': 'sample',
      'date': Timestamp.fromDate(onlyDate), // Chỉ lưu ngày
    });

    // Tạo sub-collection outcome
    await userDocRef.collection('outcome').doc('sampleOutcome').set({
      'title': 'Sample Outcome',
      'amount': 0,
      'tag': 'sample',
      'date': Timestamp.fromDate(onlyDate), // Chỉ lưu ngày
    });

    // Tạo sub-collection saving
    await userDocRef.collection('saving').doc('sampleSaving').set({
      'title': 'Sample Saving',
      'amount': 0,
      'tag': 'sample',
      'date': Timestamp.fromDate(onlyDate), // Chỉ lưu ngày
    });

    // Tạo sub-collection tag
    await userDocRef.collection('tag').doc('sampleTag').set({
      'tag': 'sample',
    });

    print('User database created successfully');
  } catch (e) {
    print('Error creating user database: $e');
  }
}

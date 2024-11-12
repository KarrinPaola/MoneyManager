import 'package:cloud_firestore/cloud_firestore.dart';

class SavingService {
  Future<double> getTotalAmount(String userId) async {
    double totalAmountSum = 0.0;

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final QuerySnapshot snapshot =
          await userDocRef.collection('saving').get();

      for (var doc in snapshot.docs) {
        totalAmountSum += doc['totalAmount'];
      }

      print('Total amount: $totalAmountSum');
    } catch (e) {
      print('Error fetching total amount: $e');
      return 0.0; // Return 0 in case of an error
    }

    return totalAmountSum;
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

  Future<List<Map<String, dynamic>>> getAllSavings(String userId) async {
    List<Map<String, dynamic>> savingsList = [];

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final QuerySnapshot snapshot = await userDocRef
          .collection('saving')
          .orderBy('date',
              descending: true) // Sắp xếp theo ngày, từ mới nhất đến cũ nhất
          .get();

      for (var doc in snapshot.docs) {
        savingsList.add({
          'title': doc['title'],
          'currentAmount': doc['currentAmount'],
          'totalAmount': doc['totalAmount'],
          'date': doc['date'], // Đảm bảo thêm trường ngày vào danh sách
        });
      }

      print('Fetched ${savingsList.length} savings records');
    } catch (e) {
      print('Error fetching savings: $e');
    }

    return savingsList;
  }
}

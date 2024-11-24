import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../userID_Store.dart';

class SavingService {
  // Trạng thái xóa để hiển thị vòng quay tải
  bool isDeleting = false;

  // Fetches total amount sum for the user
  Future<double> getTotalAmount(String userId) async {
    double totalAmountSum = 0.0;

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final QuerySnapshot snapshot = await userDocRef.collection('saving').get();

      for (var doc in snapshot.docs) {
        // Summing up totalAmount values from user's savings data
        totalAmountSum += doc['totalAmount'];
      }

      print('Total amount: $totalAmountSum');
    } catch (e) {
      print('Error fetching total amount: $e');
      return 0.0; // Return 0 if an error occurs
    }

    return totalAmountSum;
  }

  // Fetches total current amount sum for the user
  Future<double> getTotalCurrentAmount(String userId) async {
    double currentAmountSum = 0.0;

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final QuerySnapshot snapshot = await userDocRef.collection('saving').get();

      for (var doc in snapshot.docs) {
        // Summing up currentAmount values from user's savings data
        currentAmountSum += doc['currentAmount'];
      }

      print('Total current amount: $currentAmountSum');
    } catch (e) {
      print('Error fetching current amount: $e');
      return 0.0; // Return 0 if an error occurs
    }

    return currentAmountSum;
  }

  // Fetches all savings data for the user
  Future<List<Map<String, dynamic>>> getAllSavings(String userId) async {
    List<Map<String, dynamic>> savingsList = [];

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final QuerySnapshot snapshot = await userDocRef
          .collection('saving')
          .orderBy('date', descending: true) // Sorting by date
          .get();

      for (var doc in snapshot.docs) {
        savingsList.add({
          'id': doc.id, // Document ID for deletion purposes
          'title': doc['title'],
          'currentAmount': doc['currentAmount'],
          'totalAmount': doc['totalAmount'],
          'date': doc['date'], // Date field
        });
      }

      print('Fetched ${savingsList.length} savings records');
    } catch (e) {
      print('Error fetching savings: $e');
    }

    return savingsList;
  }

  // Method to delete a savings goal
  Future<void> deleteSaving(String id) async {
    if (isDeleting) return; // Prevent redundant deletion operations

    // Update isDeleting status to show loading spinner
    isDeleting = true;

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(UserStorage.userId);

      // Delete a savings goal from the 'saving' collection
      await userDocRef.collection('saving').doc(id).delete();
      print('Savings goal deleted successfully');
    } catch (e) {
      print('Error deleting savings goal: $e');
      rethrow;  // Rethrow error for additional error handling if needed
    } finally {
      // End isDeleting status
      isDeleting = false;
    }
  }
}

// Method to handle deletion and update the UI
Future<void> handleDeleteSaving(SavingService savingService, String id) async {
  if (!savingService.isDeleting) {
    await savingService.deleteSaving(id);
    // Call function to fetch new data after successful deletion
    // fetchSavings();  // Update savings list after deletion
  }
}

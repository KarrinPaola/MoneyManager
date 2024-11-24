import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> AddMoneyDatabase(
  String userId,
  String documentId, // Document ID to identify which record to update
  String title,
  double totalAmount,
  double currentAmount,
) async {
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    // Updating the existing saving document
    await userDocRef.collection('saving').doc(documentId).update({
      'title': title,
      'totalAmount': totalAmount,
      'currentAmount': currentAmount,
      'updatedAt': Timestamp.now(), // Optional field to keep track of the update time
    });

    print('Saving goal updated successfully');
  } catch (e) {
    print('Error updating saving goal: $e');
  }
}

Future<double> getTotalCurrentAmount(String userId) async {
  double currentAmountSum = 0.0;

  try {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final QuerySnapshot snapshot = await userDocRef.collection('saving').get();

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

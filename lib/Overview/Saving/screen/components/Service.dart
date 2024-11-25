import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addIgnoredGoalWithAmount(
      String userId, String goalId, double currentAmount) async {
    try {
      DocumentReference userDoc = _db.collection('users').doc(userId);

      // Lấy danh sách ignored_goals hiện tại
      DocumentSnapshot snapshot = await userDoc.get();
      List<dynamic> currentIgnoredGoals =
          (snapshot.data() as Map<String, dynamic>?)?['ignored_goals'] ?? [];

      // Cập nhật danh sách với goal mới
      List<Map<String, dynamic>> updatedIgnoredGoals =
          List<Map<String, dynamic>>.from(currentIgnoredGoals
              .map((e) => Map<String, dynamic>.from(e as Map)));

      int existingIndex =
          updatedIgnoredGoals.indexWhere((goal) => goal['id'] == goalId);

      if (existingIndex != -1) {
        updatedIgnoredGoals[existingIndex]['currentAmount'] = currentAmount;
      } else {
        updatedIgnoredGoals.add({'id': goalId, 'currentAmount': currentAmount});
      }

      // Lưu vào Firestore
      await userDoc.update({'ignored_goals': updatedIgnoredGoals});
      print("Lưu ignored goal thành công: $updatedIgnoredGoals");
    } catch (e) {
      print("Lỗi khi lưu ignored_goals: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getIgnoredGoalsWithAmounts(
      String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        List<dynamic> ignoredGoals =
            (snapshot.data() as Map<String, dynamic>?)?['ignored_goals'] ?? [];
        return List<Map<String, dynamic>>.from(
            ignoredGoals.map((e) => Map<String, dynamic>.from(e as Map)));
      }
      return [];
    } catch (e) {
      print("Lỗi khi lấy danh sách ignored_goals: $e");
      return [];
    }
  }
}

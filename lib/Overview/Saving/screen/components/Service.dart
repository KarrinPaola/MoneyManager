import 'package:back_up/userID_Store.dart';
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

  Future<List<Map<String, dynamic>>> getGoals(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } catch (e) {
    print('Error fetching goals: $e');
    return [];  // Trả về danh sách rỗng nếu có lỗi
  }
}


  Future<void> updateSaving(String userId, String goalId, double updatedAmount) async {
    try {
      // Truy cập document của mục tiêu trong Firestore
      await _db
          .collection('users') // Truy cập collection 'users'
          .doc(userId) // Truy cập document theo userId
          .collection('goals') // Truy cập sub-collection 'goals'
          .doc(goalId) // Truy cập document theo goalId
          .update({
        'currentAmount': updatedAmount, // Cập nhật giá trị 'currentAmount' với giá trị mới
      });
      print('Cập nhật thành công mục tiêu $goalId với số tiền $updatedAmount');
    } catch (e) {
      print('Lỗi khi cập nhật mục tiêu $goalId: $e');
    }
  }

  Future<void> updateSavingAmount(String goalId, double newAmount) async {
    try {
      // Cập nhật lại mục tiêu tiết kiệm trong Firestore
      await _db.collection('users')
          .doc(UserStorage.userId) // Dùng User ID của người dùng
          .collection('saving')
          .doc(goalId) // Tìm mục tiêu theo ID
          .update({
            'currentAmount': newAmount, // Cập nhật currentAmount mới
          });
      print("Cập nhật thành công currentAmount: $newAmount");
    } catch (e) {
      print("Lỗi khi cập nhật currentAmount: $e");
      throw Exception("Không thể cập nhật currentAmount.");
    }
  }

  // Phương thức lưu số tiền thừa vào Firestore
  Future<void> setTienThua(String userId, List<Map<String, dynamic>> tienThuaList) async {
  try {
    DocumentReference userDoc = _db.collection('users').doc(userId);

    // Đẩy dữ liệu 'tien_thua' lên Firestore
    await userDoc.set({'tien_thua': tienThuaList}, SetOptions(merge: true));
    print("Đã lưu 'tien_thua' thành công: $tienThuaList");
  } catch (e) {
    print("Lỗi khi lưu 'tien_thua': $e");
    rethrow;
  }
}



}

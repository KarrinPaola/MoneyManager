import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Hàm thêm ID mục tiêu vào danh sách ignored_goals của người dùng
  Future<void> addIgnoredGoal(String userId, String goalId) async {
    try {
      // Cập nhật trường ignored_goals của người dùng trong Firestore
      await _db.collection('users').doc(userId).update({
        'ignored_goals': FieldValue.arrayUnion([goalId]),
      });
    } catch (e) {
      print("Lỗi khi lưu ID mục tiêu bị bỏ qua: $e");
    }
  }

  // Hàm lấy danh sách ignored_goals của người dùng
  Future<List<String>> getIgnoredGoals(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        List<dynamic> ignoredGoals = doc.get('ignored_goals') ?? [];
        return List<String>.from(ignoredGoals);
      } else {
        return [];
      }
    } catch (e) {
      print("Lỗi khi lấy danh sách ignored_goals: $e");
      return [];
    }
  }
}

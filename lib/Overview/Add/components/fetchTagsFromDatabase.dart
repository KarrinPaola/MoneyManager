import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../userID_Store.dart';

Future<List<String>> fetchTagsFromDatabase() async {
  try {
    // Lấy reference của user document từ Firestore
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(UserStorage.userId);

    // Lấy tất cả document trong collection 'tag'
    QuerySnapshot snapshot = await userDocRef.collection('tag').get();

    // Khởi tạo list để chứa các tag
    List<String> tags = [];

    // Duyệt qua các document và lấy giá trị của field 'tag'
    for (var doc in snapshot.docs) {
      tags.add(doc.get('tag') as String);
    }

    // Trả về danh sách tag
    return tags;
  } catch (e) {
    print("Error fetching tags: $e");
    return []; // Trả về danh sách rỗng nếu có lỗi xảy ra
  }
}

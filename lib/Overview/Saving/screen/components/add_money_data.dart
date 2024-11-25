import 'package:cloud_firestore/cloud_firestore.dart';

/// Cập nhật currentAmount cho một mục tiêu tiết kiệm
Future<void> AddMoneyDatabase(
  String userId,
  String documentId, // Document ID để xác định bản ghi cần cập nhật
  String title,
  double currentAmount, // Chỉ sử dụng currentAmount
) async {
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    // Cập nhật document trong collection 'saving'
    await userDocRef.collection('saving').doc(documentId).update({
      'title': title, // Cập nhật tiêu đề (nếu cần)
      'currentAmount': currentAmount, // Cập nhật số tiền hiện tại
      'updatedAt': Timestamp.now(), // Tùy chọn: lưu thời gian cập nhật
    });

    print('Cập nhật mục tiêu tiết kiệm thành công');
  } catch (e) {
    print('Lỗi khi cập nhật mục tiêu tiết kiệm: $e');
    throw e; // Tùy chọn: ném lỗi để xử lý ở nơi gọi hàm
  }
}

/// Tính tổng currentAmount của tất cả các mục tiêu tiết kiệm
Future<double> getTotalCurrentAmount(String userId) async {
  double currentAmountSum = 0.0;

  try {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Lấy tất cả các document trong collection 'saving'
    final QuerySnapshot snapshot = await userDocRef.collection('saving').get();

    // Duyệt qua từng document và cộng dồn giá trị của 'currentAmount'
    for (var doc in snapshot.docs) {
      final currentAmount = doc['currentAmount'] as num? ?? 0.0;
      currentAmountSum += currentAmount.toDouble();
    }

    print('Tổng số tiền đã tiết kiệm: $currentAmountSum');
  } catch (e) {
    print('Lỗi khi lấy tổng số tiền tiết kiệm: $e');
    return 0.0; // Trả về 0 nếu có lỗi
  }

  return currentAmountSum;
}

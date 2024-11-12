import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final String? title;
  final String? date;
  final String? amount;
  final String? tagName;
  final VoidCallback onDelete;

  const ItemWidget({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.tagName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("selected");
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cảnh báo'),
              content: const Text('Bạn có chắc chắn muốn xoá ghi chú này?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Huỷ'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                ),
                TextButton(
                  child: const Text('Xác nhận'),
                  onPressed: () {
                    onDelete(); // Gọi hàm xóa
                    Navigator.of(context).pop(); // Đóng dialog sau khi xoá
                  },
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.money, color: Color(0xFF000000)),
                const SizedBox(width: 20),
                // Hiển thị thông tin bên trái (title, date)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null && title!.isNotEmpty)
                      Text(
                        title!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    if (date != null && date!.isNotEmpty)
                      Text(
                        date!,
                        style: const TextStyle(color: Color(0xFF9ba1a8)),
                      ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (amount != null && amount!.isNotEmpty)
                  Text(
                    amount!,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                if (tagName != null && tagName!.isNotEmpty)
                  Text(
                    tagName!,
                    style: const TextStyle(color: Color(0xFF9ba1a8)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

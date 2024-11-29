import 'package:flutter/material.dart';

class ContributionType {
  String? contributionType;

  // Hàm hiển thị hộp thoại để chọn loại đóng góp
  Future<void> showContributionTypeDialog(BuildContext context, Function(String) onSelected) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Hàng ngày'),
                onTap: () {
                  contributionType = 'Hàng ngày';
                  onSelected(contributionType!); // Gọi hàm callback
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Hàng tuần'),
                onTap: () {
                  contributionType = 'Hàng tuần';
                  onSelected(contributionType!); // Gọi hàm callback
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Hàng tháng'),
                onTap: () {
                  contributionType = 'Hàng tháng';
                  onSelected(contributionType!); // Gọi hàm callback
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Hàng năm'),
                onTap: () {
                  contributionType = 'Hàng năm';
                  onSelected(contributionType!); // Gọi hàm callback
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

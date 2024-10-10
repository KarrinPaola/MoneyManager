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
                title: Text('Daily'),
                onTap: () {
                  contributionType = 'Daily';
                  onSelected(contributionType!); // Gọi hàm callback
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                title: Text('Weekly'),
                onTap: () {
                  contributionType = 'Weekly';
                  onSelected(contributionType!); // Gọi hàm callback
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                title: Text('Monthly'),
                onTap: () {
                  contributionType = 'Monthly';
                  onSelected(contributionType!); // Gọi hàm callback
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                title: Text('Yearly'),
                onTap: () {
                  contributionType = 'Yearly';
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

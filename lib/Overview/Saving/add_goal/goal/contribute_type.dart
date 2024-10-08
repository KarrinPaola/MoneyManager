import 'package:back_up/Overview/Saving/add_goal/ch%E1%BB%A9c%20n%C4%83ng/contributefield.dart';
import 'package:flutter/material.dart';


class ContributionTypeField extends StatefulWidget {
  final TextEditingController controller;

  ContributionTypeField({required this.controller});

  @override
  _ContributionTypeFieldState createState() => _ContributionTypeFieldState();
}

class _ContributionTypeFieldState extends State<ContributionTypeField> {
  final ContributionType _contributionType = ContributionType(); // Khởi tạo lớp logic

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10), // Thêm margin ở đây
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contribution Type',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 172, 193),
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () async {
              // Hiển thị dialog để chọn loại đóng góp
              await _contributionType.showContributionTypeDialog(context, (selectedType) {
                setState(() {
                  // Cập nhật giá trị vào controller
                  widget.controller.text = selectedType;
                });
              });
            },
            child: AbsorbPointer(
              child: TextField(
                controller: widget.controller,
                readOnly: true, // Chỉ cho phép chọn thông qua dialog
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  hintText: _contributionType.contributionType ?? "Select Type",
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: const Color(0xFF9ba1a8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

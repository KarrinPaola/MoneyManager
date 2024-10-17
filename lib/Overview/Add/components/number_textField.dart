import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberTextfield extends StatelessWidget {
  const NumberTextfield(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText,
      this.prefixIcon,
      this.statusLogin,
      this.suffixIcon});

  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final bool? statusLogin;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        style: const TextStyle(color: Color(0xFF000000)),
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
          ThousandsSeparatorInputFormatter(), // Formatter tùy chỉnh
        ],
        decoration: InputDecoration(
            prefixIcon: Icon(
              prefixIcon,
              color: const Color(0xFF000000),
            ),
            suffixIcon: Icon(
              suffixIcon,
              color: const Color(0xff000000),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: statusLogin == false
                        ? Colors.red
                        : const Color(0xFF9ba1a8)),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: statusLogin == false
                        ? Colors.red
                        : const Color(0xFF1e42f9),
                    width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            fillColor: const Color(0xfffffffff),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
            )),
      ),
    );
  }
}

// Formatter tùy chỉnh để thêm dấu phân cách hàng nghìn bằng dấu chấm
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Xóa dấu phân cách cũ để xử lý lại
    String text = newValue.text.replaceAll('.', '');

    if (text.isEmpty) return newValue;

    // Định dạng số với dấu phân cách hàng nghìn bằng dấu chấm
    final formattedText = NumberFormat('#,###', 'vi')
        .format(int.parse(text))
        .replaceAll(',', '.');

    // Trả về giá trị mới với dấu phân cách và con trỏ được đặt lại
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

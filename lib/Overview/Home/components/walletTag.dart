import 'package:flutter/material.dart';

class WalletTag extends StatefulWidget {
  final String title;
  final num money;
  final VoidCallback onTap;
  final bool leftMargin;
  final bool rightMargin; // Hàm callback khi người dùng nhấn vào widget

  const WalletTag({
    super.key,
    required this.title,
    required this.money,
    required this.onTap,
    required this.leftMargin,
    required this.rightMargin,
  });

  @override
  State<WalletTag> createState() => _WalletTagState();
}

class _WalletTagState extends State<WalletTag> {
  bool isSelected = false; // Trạng thái để kiểm tra xem có được chọn hay không

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("WalletTag tapped"); // Thêm dòng này để kiểm tra
        setState(() {
          isSelected = !isSelected; // Đổi trạng thái khi được nhấn
        });
        widget.onTap(); // Gọi hàm callback từ cha
      },
      child: Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: widget.leftMargin ? 20 : 10,
            right: widget.rightMargin ? 20 : 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              isSelected ? const Color(0xFF1e42f9) : const Color(0xFFFFFFFF), // Đổi màu nền
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Màu của shadow
              spreadRadius: 2, // Bán kính lan rộng của shadow
              blurRadius: 5, // Bán kính làm mờ shadow
              offset: const Offset(0, 3), // Độ dịch chuyển của shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.wallet,
              size: 30,
              color: isSelected ? Colors.white : Colors.black, // Đổi màu icon
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black, // Đổi màu chữ
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '\$${widget.money}',
              style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.black, // Đổi màu số tiền
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

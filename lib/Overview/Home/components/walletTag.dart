import 'package:flutter/material.dart';

class WalletTag extends StatefulWidget {
  final String title;
  final String money;
  final VoidCallback onTap;
  final Function(int) onTap2;
  final bool leftMargin;
  final bool rightMargin; // Hàm callback khi người dùng nhấn vào widget
  final int index;
  final int selectedWalletTag;

  const WalletTag({
    super.key,
    required this.title,
    required this.money,
    required this.onTap,
    required this.leftMargin,
    required this.rightMargin,
    required this.index,
    required this.selectedWalletTag,
    required this.onTap2,
  });

  @override
  State<WalletTag> createState() => _WalletTagState();
}

class _WalletTagState extends State<WalletTag> {
  // Trạng thái để kiểm tra xem có được chọn hay không

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(); // Gọi hàm callback từ cha
        widget.onTap2(widget.index);
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
          color: widget.index == widget.selectedWalletTag
              ? const Color(0xFF1e42f9)
              : const Color(0xFFFFFFFF), // Đổi màu nền
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
              color: widget.index == widget.selectedWalletTag
                  ? Colors.white
                  : Colors.black, // Đổi màu icon
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: widget.index == widget.selectedWalletTag
                    ? Colors.white
                    : Colors.black, // Đổi màu chữ
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.money,
              style: TextStyle(
                  color: widget.index == widget.selectedWalletTag
                      ? Colors.white
                      : Colors.black, // Đổi màu số tiền
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

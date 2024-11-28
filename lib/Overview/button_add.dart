import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  const ButtonAdd({
    super.key,
    required this.title,
    required this.ontap,
  });
  final String title;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        decoration: BoxDecoration(
            color: const Color(0xFF1e42f9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Màu của shadow
                spreadRadius: 2, // Bán kính lan rộng của shadow
                blurRadius: 5, // Bán kính làm mờ shadow
                offset: const Offset(0, 3), // Độ dịch chuyển của shadow
              ),
            ]),
        child: Row(
          children: [
            const Icon(
              Icons.add,
              color: Color(0xffffffff),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.none,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

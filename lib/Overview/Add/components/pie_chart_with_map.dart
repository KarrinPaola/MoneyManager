import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Lớp PieChartWithMap cho phép hiển thị biểu đồ tròn dựa trên dữ liệu từ incomeByTag
class PieChartWithMap extends StatefulWidget {
  final Map<String, double> incomeByTag; // Dữ liệu thu nhập theo tag

  const PieChartWithMap({super.key, required this.incomeByTag});

  @override
  State<StatefulWidget> createState() => PieChartWithMapState();
}

class PieChartWithMapState extends State<PieChartWithMap> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa ngang cho cả biểu đồ và chú thích
      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa dọc cho cả biểu đồ và chú thích
      children: <Widget>[
        Expanded(
          flex: 2, // Tỉ lệ phần không gian dành cho biểu đồ
          child: AspectRatio(
            aspectRatio: 1, // Tỉ lệ cho biểu đồ
            child: PieChart(
              PieChartData(
                // Loại bỏ xử lý tương tác chạm
                borderData: FlBorderData(
                  show: true, // Không hiển thị đường biên
                ),
                sectionsSpace: 0, // Khoảng cách giữa các phần
                centerSpaceRadius: 45, // Bán kính không gian giữa
                sections: showingSections(), // Hiển thị các phần dựa trên dữ liệu
              ),
            ),
          ),
        ),
        const SizedBox(width: 20), // Khoảng cách giữa biểu đồ và chú thích
        Expanded(
          flex: 1, // Tỉ lệ phần không gian dành cho chú thích
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa dọc cho các chú thích
            crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho các chú thích
            children: widget.incomeByTag.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10), // Khoảng cách giữa các chú thích
                child: Indicator(
                  color: Colors.primaries[
                      widget.incomeByTag.keys.toList().indexOf(entry.key) %
                          Colors.primaries.length], // Chọn màu cho từng tag
                  text: entry.key, // Tên tag
                  isSquare: true, // Chọn kiểu hình vuông cho indicator
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Hàm tạo danh sách các phần cho biểu đồ
  List<PieChartSectionData> showingSections() {
    final keys = widget.incomeByTag.keys.toList(); // Lấy danh sách keys từ incomeByTag
    final values = widget.incomeByTag.values.toList(); // Lấy danh sách values từ incomeByTag
    const colors = Colors.primaries; // Sử dụng danh sách màu sắc mặc định

    return List.generate(keys.length, (i) {
      // Bỏ tính năng chạm để phóng to
      const fontSize = 13.0; // Kích thước chữ cố định
      const radius = 50.0; // Bán kính cố định
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)]; // Đổ bóng cho chữ

      // Trả về dữ liệu cho từng phần của biểu đồ
      return PieChartSectionData(
        color: colors[i % colors.length], // Chọn màu cho từng phần
        value: values[i], // Giá trị cho từng phần
        title: '${values[i].toStringAsFixed(1)}%', // Hiển thị giá trị phần trăm
        radius: radius, // Bán kính cố định cho phần
        titleStyle: const TextStyle(
          fontSize: fontSize, // Kích thước chữ cố định
          fontWeight: FontWeight.bold, // Đậm
          color: Colors.white, // Màu chữ
          shadows: shadows, // Đổ bóng cho chữ
        ),
      );
    });
  }
}

// Lớp Indicator để hiển thị phần chú thích
class Indicator extends StatelessWidget {
  final Color color; // Màu sắc của chỉ số
  final String text; // Văn bản của chỉ số
  final bool isSquare; // Kiểu hình dáng

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hình vuông hoặc hình tròn cho chỉ số
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle, // Hình dáng
          ),
        ),
        const SizedBox(
          width: 8, // Khoảng cách giữa chỉ số và văn bản
        ),
        Text(text), // Hiển thị văn bản của chỉ số
      ],
    );
  }
}
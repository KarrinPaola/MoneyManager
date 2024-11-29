import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Giới thiệu',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Dự án được thực hiện bởi tổ đội 3 anh em siu nhân!!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  softWrap: true,
                ),
              ),
              
              // Team Member 1
              _buildTeamMemberCard(
                name: 'Lê Trung Hiếu \n- Trưởng nhóm',
                responsibilities: 'Thiết kế giao diện\nThiết kế cơ sở dữ liệu\nThiết kế xác thực\nThiết kế trang tổng quan\nThiết kế quản lý thu chi',
              ),
              
              // Team Member 2
              _buildTeamMemberCard(
                name: 'Nguyễn Đình Đức Trung',
                responsibilities: 'Thiết kế quản lý mục tiết kiệm',
              ),
              
              // Team Member 3
              _buildTeamMemberCard(
                name: 'Phạm Việt Hoàng',
                responsibilities: 'Thiết kế cài đặt',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to create team member cards
  Widget _buildTeamMemberCard({required String name, required String responsibilities}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          // Name Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  softWrap: true,
                ),
              ],
            ),
          ),
          
          // Responsibilities Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  responsibilities,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.right,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
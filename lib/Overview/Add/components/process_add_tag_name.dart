import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../userID_Store.dart';

Future<void> Process_Add_Tag(
  BuildContext context,
  VoidCallback onTagAdded, // Thêm callback
  String nameCollectionTag,
) async {
  TextEditingController newTagController = TextEditingController();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add New Tag'),
        content: TextField(
          controller: newTagController,
          decoration: const InputDecoration(
            hintText: 'Enter new tag name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Lấy tag mới và loại bỏ ký tự khoảng trắng
              String newTag = newTagController.text.trim();
              if (newTag.isNotEmpty) {
                // Cập nhật tag mới vào Firestore
                final userDocRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserStorage.userId);
                try {
                  await userDocRef.collection(nameCollectionTag).doc(newTag).set({
                    'tag': newTag,
                  });
                  print('Tag added to Firebase: $newTag');
                  onTagAdded(); // Gọi callback để tải lại tag
                } catch (e) {
                  print("Error adding tag: $e");
                }
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

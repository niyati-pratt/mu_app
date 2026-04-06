import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String id, title, body, category, author;
  final DateTime createdAt;
  final String? targetClass;
  final bool isPinned;

  NoticeModel({
    required this.id, required this.title,
    required this.body, required this.category,
    required this.author, required this.createdAt,
    this.targetClass, this.isPinned = false,
  });

  factory NoticeModel.fromFirestore(
      Map<String, dynamic> d, String id) =>
    NoticeModel(
      id: id, title: d['title'] ?? '',
      body: d['body'] ?? '',
      category: d['category'] ?? 'general',
      author: d['author'] ?? 'Admin',
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      targetClass: d['targetClass'],
      isPinned: d['isPinned'] ?? false,
    );

  Map<String, dynamic> toFirestore() => {
    'title': title, 'body': body,
    'category': category, 'author': author,
    'createdAt': createdAt,
    'targetClass': targetClass,
    'isPinned': isPinned,
  };
}
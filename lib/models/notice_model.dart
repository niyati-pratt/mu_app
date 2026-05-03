import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String id;
  final String title;
  final String body;
  final String category; // 'general' | 'urgent' | 'academic' | 'event'
  final String author;
  final Timestamp? createdAt;
  final String? targetClass; // null = all students
  final bool isPinned;

  NoticeModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.author,
    this.createdAt,
    this.targetClass,
    this.isPinned = false,
  });

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoticeModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      category: data['category'] ?? 'general',
      author: data['author'] ?? '',
      createdAt: data['createdAt'],
      targetClass: data['targetClass'],
      isPinned: data['isPinned'] == true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'body': body,
    'category': category,
    'author': author,
    'createdAt': FieldValue.serverTimestamp(),
    if (targetClass != null) 'targetClass': targetClass,
    'isPinned': isPinned,
  };
}
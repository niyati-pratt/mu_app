import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'student' | 'faculty' | 'parent' | 'admin'
  final String? department;
  final String? studentClass;
  final Timestamp? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.department,
    this.studentClass,
    this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      department: data['department'],
      studentClass: data['studentClass'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'role': role,
    if (department != null) 'department': department,
    if (studentClass != null) 'studentClass': studentClass,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
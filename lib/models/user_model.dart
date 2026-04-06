class UserModel {
  final String uid, name, email, role;
  final String? department, studentClass;

  UserModel({
    required this.uid, required this.name,
    required this.email, required this.role,
    this.department, this.studentClass,
  });

  factory UserModel.fromFirestore(
      Map<String, dynamic> d, String uid) =>
    UserModel(
      uid: uid, name: d['name'] ?? '',
      email: d['email'] ?? '',
      role: d['role'] ?? 'student',
      department: d['department'],
      studentClass: d['studentClass'],
    );

  Map<String, dynamic> toFirestore() => {
    'name': name, 'email': email,
    'role': role, 'department': department,
    'studentClass': studentClass,
  };
}
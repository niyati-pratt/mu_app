import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  UserModel? _user;
  bool _loading = false;

  UserModel? get currentUser  => _user;
  bool get isLoggedIn  => _user != null;
  bool get isLoading   => _loading;
  String? get role     => _user?.role;

  AuthProvider() {
    _auth.authStateChanges().listen((u) async {
      if (u != null) {
        final doc = await _db
          .collection('users').doc(u.uid).get();
        if (doc.exists)
          _user = UserModel.fromFirestore(doc.data()!, u.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<String?> login(String email, String pw) async {
    _loading = true; notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: pw);
      _loading = false; notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _loading = false; notifyListeners();
      switch (e.code) {
        case 'user-not-found': return 'No account with this email.';
        case 'wrong-password': return 'Incorrect password.';
        default: return 'Login failed. Try again.';
      }
    }
  }

  Future<String?> register({
    required String name, required String email,
    required String password, required String role,
    String? department, String? studentClass,
  }) async {
    _loading = true; notifyListeners();
    try {
      final c = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
      await _db.collection('users').doc(c.user!.uid).set({
        'name': name, 'email': email.trim(),
        'role': role, 'department': department,
        'studentClass': studentClass,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _loading = false; notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _loading = false; notifyListeners();
      return e.code == 'email-already-in-use'
        ? 'Email already registered.'
        : 'Registration failed.';
    }
  }

  Future<void> logout() => _auth.signOut();
}
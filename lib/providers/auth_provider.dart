import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get role => _user?.role ?? 'student';

  AuthProvider() {
    // Listen to Firebase Auth state changes
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
    } else {
      await _fetchUserDocument(firebaseUser.uid);
    }
    notifyListeners();
  }

  Future<void> _fetchUserDocument(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching user document: $e');
    }
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return null; // null = success
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _mapAuthError(e.code);
      notifyListeners();
      return _error;
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? department,
    String? studentClass,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Create Firestore user document
      final newUser = UserModel(
        uid: credential.user!.uid,
        name: name.trim(),
        email: email.trim(),
        role: role,
        department: department,
        studentClass: studentClass,
      );

      await _db
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toFirestore());

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _mapAuthError(e.code);
      notifyListeners();
      return _error;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
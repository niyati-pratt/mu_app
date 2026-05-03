import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice_model.dart';

class NoticesProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<NoticeModel> _notices = [];
  bool _isLoading = false;
  String? _error;

  List<NoticeModel> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch notices — filters by studentClass if provided (null = faculty, fetches all)
  Future<void> fetch({String? studentClass}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Query query = _db
          .collection('notices')
          .orderBy('createdAt', descending: true)
          .limit(50);

      final snapshot = await query.get();
      List<NoticeModel> all = snapshot.docs
          .map((doc) => NoticeModel.fromFirestore(doc))
          .toList();

      // Client-side filter: show global notices + class-specific notices
      if (studentClass != null) {
        _notices = all.where((n) =>
          n.targetClass == null || n.targetClass == studentClass
        ).toList();
      } else {
        _notices = all;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load notices.';
      print('Error fetching notices: $e');
      notifyListeners();
    }
  }

  Future<bool> post(NoticeModel notice) async {
    try {
      await _db.collection('notices').add(notice.toFirestore());
      return true;
    } catch (e) {
      print('Error posting notice: $e');
      return false;
    }
  }
}
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice_model.dart';

class NoticesProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<NoticeModel> _notices = [];
  bool _loading = false;
  String? _error;

  List<NoticeModel> get notices  => _notices;
  bool get isLoading => _loading;
  String? get error  => _error;

  Future<void> fetch({String? studentClass}) async {
    _loading = true; _error = null; notifyListeners();
    try {
      final snap = await _db.collection('notices')
        .orderBy('createdAt', descending: true)
        .limit(50).get();
      _notices = snap.docs
        .map((d) => NoticeModel.fromFirestore(d.data(), d.id))
        .where((n) => studentClass == null ||
          n.targetClass == null ||
          n.targetClass == studentClass)
        .toList();
    } catch (e) { _error = 'Failed to load notices.'; }
    _loading = false; notifyListeners();
  }

  Future<bool> post(NoticeModel n) async {
    try {
      await _db.collection('notices').add(n.toFirestore());
      await fetch();
      return true;
    } catch (_) { return false; }
  }
}
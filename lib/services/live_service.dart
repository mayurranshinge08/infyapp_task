import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LiveService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLive = false;
  String? _currentLiveUserId;
  String? _meetingId;
  String? _meetingPassword;

  bool get isLive => _isLive;
  String? get currentLiveUserId => _currentLiveUserId;
  String? get meetingId => _meetingId;
  String? get meetingPassword => _meetingPassword;

  // Check live status
  Future<void> checkLiveStatus() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('live_status')
          .doc('current')
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _isLive = data['isLive'] ?? false;
        _currentLiveUserId = data['userId'];
        _meetingId = data['meetingId'];
        _meetingPassword = data['meetingPassword'];
      } else {
        _isLive = false;
        _currentLiveUserId = null;
        _meetingId = null;
        _meetingPassword = null;
      }
    } catch (e) {
      _isLive = false;
      _currentLiveUserId = null;
    }

    notifyListeners();
  }

  // Start live session
  Future<String?> startLive(String userId) async {
    try {
      // Generate meeting ID and password
      String meetingId = DateTime.now().millisecondsSinceEpoch.toString();
      String meetingPassword = '123456';

      await _firestore.collection('live_status').doc('current').set({
        'isLive': true,
        'userId': userId,
        'meetingId': meetingId,
        'meetingPassword': meetingPassword,
        'startedAt': FieldValue.serverTimestamp(),
      });

      _isLive = true;
      _currentLiveUserId = userId;
      _meetingId = meetingId;
      _meetingPassword = meetingPassword;

      notifyListeners();
      return null; // Success
    } catch (e) {
      return 'Failed to start live session';
    }
  }

  // End live session
  Future<String?> endLive() async {
    try {
      await _firestore.collection('live_status').doc('current').delete();

      _isLive = false;
      _currentLiveUserId = null;
      _meetingId = null;
      _meetingPassword = null;

      notifyListeners();
      return null; // Success
    } catch (e) {
      return 'Failed to end live session';
    }
  }
}

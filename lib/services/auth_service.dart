import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ---------- Register ----------
  Future<String?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'profilePicture': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
      return null; // ✅ success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred during registration';
    }
  }

  // ---------- Login ----------
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null; // ✅ success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred during login';
    }
  }

  // ---------- Logout ----------
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  // ---------- Change Password (with re-authentication) ----------
  Future<String?> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Re-authenticate first
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Now update password
        await user.updatePassword(newPassword);
        return null; // ✅ success
      }
      return 'No user logged in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Something went wrong: $e';
    }
  }

  // ---------- Get User Data ----------
  Future<Map<String, dynamic>?> getUserData() async {
    if (currentUser == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  // ---------- Update User Name ----------
  Future<void> updateUserName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': name,
      });
    }
  }

  // ---------- Update Profile Picture ----------
  Future<void> updateProfilePicture(String url) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': url,
      });
    }
  }

  // Reauthenticate and change password
  Future<String?> reauthenticateAndChangePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'No user logged in';

      // Create credential for reauthentication
      final credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      // Reauthenticate
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') return 'Old password is incorrect';
      return e.message;
    } catch (e) {
      return 'Something went wrong: $e';
    }
  }
}

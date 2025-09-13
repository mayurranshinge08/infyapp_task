import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordChangeRequested>(_onAuthPasswordChangeRequested);
    on<AuthProfilePictureUpdateRequested>(_onAuthProfilePictureUpdateRequested);
    on<AuthUserDataRequested>(_onAuthUserDataRequested);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user: user));
      add(AuthUserDataRequested());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      if (credential.user != null) {
        emit(AuthAuthenticated(user: credential.user!));
        add(AuthUserDataRequested());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Login failed'));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred during login'));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (credential.user != null) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'fullName': event.fullName,
          'email': event.email,
          'profilePicture': '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        emit(AuthAuthenticated(user: credential.user!));
        add(AuthUserDataRequested());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Registration failed'));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred during registration'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _auth.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthPasswordChangeRequested(
    AuthPasswordChangeRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _auth.currentUser?.updatePassword(event.newPassword);
      emit(AuthPasswordChanged());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Password change failed'));
    } catch (e) {
      emit(
        const AuthError(message: 'An error occurred while changing password'),
      );
    }
  }

  Future<void> _onAuthProfilePictureUpdateRequested(
    AuthProfilePictureUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(const AuthError(message: 'User not logged in'));
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': event.imageUrl,
      });
      emit(AuthProfileUpdated());
      add(AuthUserDataRequested());
    } catch (e) {
      emit(const AuthError(message: 'Failed to update profile picture'));
    }
  }

  Future<void> _onAuthUserDataRequested(
    AuthUserDataRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;
        emit(AuthAuthenticated(user: user, userData: userData));
      }
    } catch (e) {
      // Keep current state if user data fetch fails
    }
  }
}

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [fullName, email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthPasswordChangeRequested extends AuthEvent {
  final String newPassword;

  const AuthPasswordChangeRequested({required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}

class AuthProfilePictureUpdateRequested extends AuthEvent {
  final String imageUrl;

  const AuthProfilePictureUpdateRequested({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class AuthUserDataRequested extends AuthEvent {}

import 'package:equatable/equatable.dart';

abstract class LiveEvent extends Equatable {
  const LiveEvent();

  @override
  List<Object?> get props => [];
}

class LiveStatusCheckRequested extends LiveEvent {}

class LiveStartRequested extends LiveEvent {
  final String userId;

  const LiveStartRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LiveEndRequested extends LiveEvent {}

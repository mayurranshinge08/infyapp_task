import 'package:equatable/equatable.dart';

abstract class LiveState extends Equatable {
  const LiveState();

  @override
  List<Object?> get props => [];
}

class LiveInitial extends LiveState {}

class LiveLoading extends LiveState {}

class LiveStatusLoaded extends LiveState {
  final bool isLive;
  final String? currentLiveUserId;
  final String? meetingId;
  final String? meetingPassword;

  const LiveStatusLoaded({
    required this.isLive,
    this.currentLiveUserId,
    this.meetingId,
    this.meetingPassword,
  });

  @override
  List<Object?> get props => [
    isLive,
    currentLiveUserId,
    meetingId,
    meetingPassword,
  ];
}

class LiveStarted extends LiveState {
  final String meetingId;
  final String meetingPassword;

  const LiveStarted({required this.meetingId, required this.meetingPassword});

  @override
  List<Object> get props => [meetingId, meetingPassword];
}

class LiveEnded extends LiveState {}

class LiveError extends LiveState {
  final String message;

  const LiveError({required this.message});

  @override
  List<Object> get props => [message];
}

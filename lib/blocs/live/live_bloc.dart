import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// EVENTS
abstract class LiveEvent {}

class CheckLiveStatus extends LiveEvent {}

class StartLive extends LiveEvent {
  final String userId;
  StartLive(this.userId);
}

class EndLive extends LiveEvent {}

// STATE
class LiveState {
  final bool isLive;
  final String? currentLiveUserId;
  final String? meetingId;
  final String? meetingPassword;

  LiveState({
    this.isLive = false,
    this.currentLiveUserId,
    this.meetingId,
    this.meetingPassword,
  });

  LiveState copyWith({
    bool? isLive,
    String? currentLiveUserId,
    String? meetingId,
    String? meetingPassword,
  }) {
    return LiveState(
      isLive: isLive ?? this.isLive,
      currentLiveUserId: currentLiveUserId ?? this.currentLiveUserId,
      meetingId: meetingId ?? this.meetingId,
      meetingPassword: meetingPassword ?? this.meetingPassword,
    );
  }
}

// BLOC
class LiveBloc extends Bloc<LiveEvent, LiveState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LiveBloc() : super(LiveState()) {
    on<CheckLiveStatus>(_onCheckLiveStatus);
    on<StartLive>(_onStartLive);
    on<EndLive>(_onEndLive);
  }

  Future<void> _onCheckLiveStatus(
    CheckLiveStatus event,
    Emitter<LiveState> emit,
  ) async {
    final doc = await _firestore.collection('live_status').doc('current').get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      emit(
        state.copyWith(
          isLive: data['isLive'] ?? false,
          currentLiveUserId: data['userId'],
          meetingId: data['meetingId'],
          meetingPassword: data['meetingPassword'],
        ),
      );
    } else {
      emit(LiveState());
    }
  }

  Future<void> _onStartLive(StartLive event, Emitter<LiveState> emit) async {
    String meetingId = DateTime.now().millisecondsSinceEpoch.toString();
    String meetingPassword = '123456';

    await _firestore.collection('live_status').doc('current').set({
      'isLive': true,
      'userId': event.userId,
      'meetingId': meetingId,
      'meetingPassword': meetingPassword,
      'startedAt': FieldValue.serverTimestamp(),
    });

    emit(
      state.copyWith(
        isLive: true,
        currentLiveUserId: event.userId,
        meetingId: meetingId,
        meetingPassword: meetingPassword,
      ),
    );
  }

  Future<void> _onEndLive(EndLive event, Emitter<LiveState> emit) async {
    await _firestore.collection('live_status').doc('current').delete();
    emit(LiveState());
  }
}

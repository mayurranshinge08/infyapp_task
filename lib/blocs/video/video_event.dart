import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class VideoLoadRequested extends VideoEvent {}

class VideoSearchRequested extends VideoEvent {
  final String query;

  const VideoSearchRequested({required this.query});

  @override
  List<Object> get props => [query];
}

class VideoSearchCleared extends VideoEvent {}

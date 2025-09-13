import 'package:equatable/equatable.dart';

import '../../models/video_model.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<VideoModel> videos;

  const VideoLoaded({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideoSearchLoaded extends VideoState {
  final List<VideoModel> searchResults;
  final String query;

  const VideoSearchLoaded({required this.searchResults, required this.query});

  @override
  List<Object> get props => [searchResults, query];
}

class VideoError extends VideoState {
  final String message;

  const VideoError({required this.message});

  @override
  List<Object> get props => [message];
}

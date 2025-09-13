import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/video_model.dart';
import 'video_event.dart';
import 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  VideoBloc() : super(VideoInitial()) {
    on<VideoLoadRequested>(_onVideoLoadRequested);
    on<VideoSearchRequested>(_onVideoSearchRequested);
    on<VideoSearchCleared>(_onVideoSearchCleared);
  }

  Future<void> _onVideoLoadRequested(
    VideoLoadRequested event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoLoading());

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      List<VideoModel> videos = snapshot.docs
          .map(
            (doc) => VideoModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();

      if (videos.isEmpty) {
        await _createSampleVideos();
        // Reload after creating samples
        snapshot = await _firestore
            .collection('videos')
            .orderBy('createdAt', descending: true)
            .limit(20)
            .get();

        videos = snapshot.docs
            .map(
              (doc) => VideoModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ),
            )
            .toList();
      }

      emit(VideoLoaded(videos: videos));
    } catch (e) {
      emit(VideoError(message: 'Failed to load videos: ${e.toString()}'));
    }
  }

  Future<void> _onVideoSearchRequested(
    VideoSearchRequested event,
    Emitter<VideoState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const VideoSearchLoaded(searchResults: [], query: ''));
      return;
    }

    try {
      // Search by tags
      QuerySnapshot snapshot = await _firestore
          .collection('videos')
          .where('tags', arrayContainsAny: [event.query.toLowerCase()])
          .get();

      List<VideoModel> searchResults = snapshot.docs
          .map(
            (doc) => VideoModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();

      // Also search by title
      QuerySnapshot titleSnapshot = await _firestore
          .collection('videos')
          .where('title', isGreaterThanOrEqualTo: event.query)
          .where('title', isLessThan: event.query + 'z')
          .get();

      List<VideoModel> titleResults = titleSnapshot.docs
          .map(
            (doc) => VideoModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();

      // Combine and remove duplicates
      Set<String> ids = searchResults.map((v) => v.id).toSet();
      for (var video in titleResults) {
        if (!ids.contains(video.id)) {
          searchResults.add(video);
        }
      }

      emit(VideoSearchLoaded(searchResults: searchResults, query: event.query));
    } catch (e) {
      emit(VideoError(message: 'Search failed: ${e.toString()}'));
    }
  }

  void _onVideoSearchCleared(
    VideoSearchCleared event,
    Emitter<VideoState> emit,
  ) {
    emit(const VideoSearchLoaded(searchResults: [], query: ''));
  }

  // Create sample videos for demo
  Future<void> _createSampleVideos() async {
    List<Map<String, dynamic>> sampleVideos = [
      {
        'title': 'Flutter Basics Tutorial',
        'description':
            'Learn the fundamentals of Flutter development including widgets, state management, and navigation.',
        'vimeoId': '76979871',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example1.jpg',
        'tags': ['flutter', 'tutorial', 'basics'],
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'Advanced Dart Programming',
        'description':
            'Deep dive into Dart language features, async programming, and advanced concepts.',
        'vimeoId': '76979872',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example2.jpg',
        'tags': ['dart', 'programming', 'advanced'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      },
      {
        'title': 'Firebase Integration Guide',
        'description':
            'Complete guide to integrating Firebase services in your Flutter applications.',
        'vimeoId': '76979873',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example3.jpg',
        'tags': ['firebase', 'backend', 'integration'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
      },
      {
        'title': 'State Management with BLoC',
        'description':
            'Learn how to manage application state effectively using the BLoC pattern.',
        'vimeoId': '76979874',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example4.jpg',
        'tags': ['state', 'bloc', 'architecture'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 3)),
        ),
      },
      {
        'title': 'Building Beautiful UIs',
        'description':
            'Design principles and techniques for creating stunning user interfaces in Flutter.',
        'vimeoId': '76979875',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example5.jpg',
        'tags': ['ui', 'design', 'material'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 4)),
        ),
      },
      {
        'title': 'API Integration Tutorial',
        'description':
            'Learn how to integrate REST APIs and handle HTTP requests in Flutter applications.',
        'vimeoId': '76979876',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example6.jpg',
        'tags': ['api', 'http', 'networking'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 5)),
        ),
      },
      {
        'title': 'Animation Fundamentals',
        'description':
            'Master Flutter animations from basic tweens to complex custom animations.',
        'vimeoId': '76979877',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example7.jpg',
        'tags': ['animation', 'ui', 'effects'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 6)),
        ),
      },
      {
        'title': 'Testing Your Flutter Apps',
        'description':
            'Comprehensive guide to unit testing, widget testing, and integration testing.',
        'vimeoId': '76979878',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example8.jpg',
        'tags': ['testing', 'quality', 'debugging'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 7)),
        ),
      },
      {
        'title': 'Performance Optimization',
        'description':
            'Tips and techniques to optimize your Flutter app performance and reduce build size.',
        'vimeoId': '76979879',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example9.jpg',
        'tags': ['performance', 'optimization', 'best-practices'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 8)),
        ),
      },
      {
        'title': 'Publishing to App Stores',
        'description':
            'Step-by-step guide to publishing your Flutter app to Google Play and App Store.',
        'vimeoId': '76979880',
        'thumbnailUrl': 'https://i.vimeocdn.com/video/example10.jpg',
        'tags': ['publishing', 'deployment', 'stores'],
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 9)),
        ),
      },
    ];

    for (var video in sampleVideos) {
      await _firestore.collection('videos').add(video);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/video_model.dart';

class VideoService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<VideoModel> _videos = [];
  List<VideoModel> _searchResults = [];
  bool _isLoading = false;

  List<VideoModel> get videos => _videos;
  List<VideoModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  // Load videos from Firestore
  Future<void> loadVideos() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      _videos = snapshot.docs
          .map(
            (doc) => VideoModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      // If no videos in Firestore, create some sample data
      await _createSampleVideos();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search videos
  Future<void> searchVideos(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('videos')
          .where('tags', arrayContainsAny: [query.toLowerCase()])
          .get();

      _searchResults = snapshot.docs
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
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z')
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
      Set<String> ids = _searchResults.map((v) => v.id).toSet();
      for (var video in titleResults) {
        if (!ids.contains(video.id)) {
          _searchResults.add(video);
        }
      }
    } catch (e) {
      _searchResults = [];
    }

    notifyListeners();
  }

  // Create sample videos for demo
  Future<void> _createSampleVideos() async {
    List<Map<String, dynamic>> sampleVideos = [
      {
        'title': 'Flutter Complete Course - Introduction',
        'description':
            'Complete introduction to Flutter development covering all the basics you need to get started.',
        'youtubeId': 'VPvVD8t02U8',
        'thumbnailUrl':
            'https://img.youtube.com/vi/VPvVD8t02U8/maxresdefault.jpg',
        'tags': ['flutter', 'tutorial', 'introduction', 'basics'],
        'duration': '45:30',
        'channelName': 'Flutter Official',
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'Dart Programming Fundamentals',
        'description':
            'Learn Dart programming language fundamentals essential for Flutter development.',
        'youtubeId': 'Ej_Pcr4uC2Q',
        'thumbnailUrl':
            'https://img.youtube.com/vi/Ej_Pcr4uC2Q/maxresdefault.jpg',
        'tags': ['dart', 'programming', 'fundamentals', 'language'],
        'duration': '38:15',
        'channelName': 'Dart Language',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      },
      {
        'title': 'Flutter Widgets Deep Dive',
        'description':
            'Comprehensive guide to Flutter widgets including StatefulWidget, StatelessWidget, and custom widgets.',
        'youtubeId': 'wE7khGHVkYY',
        'thumbnailUrl':
            'https://img.youtube.com/vi/wE7khGHVkYY/maxresdefault.jpg',
        'tags': ['flutter', 'widgets', 'ui', 'components'],
        'duration': '52:20',
        'channelName': 'Flutter Community',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
      },
      {
        'title': 'State Management in Flutter',
        'description':
            'Master state management techniques in Flutter using Provider, BLoC, and other popular solutions.',
        'youtubeId': 'RS36gBEp8OI',
        'thumbnailUrl':
            'https://img.youtube.com/vi/RS36gBEp8OI/maxresdefault.jpg',
        'tags': ['flutter', 'state-management', 'bloc', 'provider'],
        'duration': '41:45',
        'channelName': 'Flutter Explained',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 3)),
        ),
      },
      {
        'title': 'Flutter Navigation and Routing',
        'description':
            'Learn how to implement navigation and routing in Flutter applications with practical examples.',
        'youtubeId': 'YXDFlpdpp3g',
        'thumbnailUrl':
            'https://img.youtube.com/vi/YXDFlpdpp3g/maxresdefault.jpg',
        'tags': ['flutter', 'navigation', 'routing', 'pages'],
        'duration': '35:10',
        'channelName': 'Flutter Tutorials',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 4)),
        ),
      },
      {
        'title': 'Firebase Integration with Flutter',
        'description':
            'Complete guide to integrating Firebase services including Authentication, Firestore, and Storage.',
        'youtubeId': 'sfA3NWDBPZ4',
        'thumbnailUrl':
            'https://img.youtube.com/vi/sfA3NWDBPZ4/maxresdefault.jpg',
        'tags': ['flutter', 'firebase', 'backend', 'authentication'],
        'duration': '48:30',
        'channelName': 'Firebase for Flutter',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 5)),
        ),
      },
      {
        'title': 'Flutter Animations Masterclass',
        'description':
            'Master Flutter animations from basic tweens to complex custom animations and transitions.',
        'youtubeId': 'GXIJJkq_H8g',
        'thumbnailUrl':
            'https://img.youtube.com/vi/GXIJJkq_H8g/maxresdefault.jpg',
        'tags': ['flutter', 'animations', 'ui', 'transitions'],
        'duration': '44:25',
        'channelName': 'Flutter Animations',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 6)),
        ),
      },
      {
        'title': 'Flutter HTTP and API Integration',
        'description':
            'Learn how to make HTTP requests and integrate REST APIs in your Flutter applications.',
        'youtubeId': 'aIJU68Phi1w',
        'thumbnailUrl':
            'https://img.youtube.com/vi/aIJU68Phi1w/maxresdefault.jpg',
        'tags': ['flutter', 'http', 'api', 'networking'],
        'duration': '39:15',
        'channelName': 'Flutter Networking',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 7)),
        ),
      },
      {
        'title': 'Flutter Testing Complete Guide',
        'description':
            'Comprehensive testing guide covering unit tests, widget tests, and integration tests in Flutter.',
        'youtubeId': 'RDY6UYh-nyg',
        'thumbnailUrl':
            'https://img.youtube.com/vi/RDY6UYh-nyg/maxresdefault.jpg',
        'tags': ['flutter', 'testing', 'quality', 'debugging'],
        'duration': '42:50',
        'channelName': 'Flutter Testing',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 8)),
        ),
      },
      {
        'title': 'Flutter App Deployment Guide',
        'description':
            'Step-by-step guide to building and deploying Flutter apps to Google Play Store and Apple App Store.',
        'youtubeId': 'akFF1uJWZck',
        'thumbnailUrl':
            'https://img.youtube.com/vi/akFF1uJWZck/maxresdefault.jpg',
        'tags': ['flutter', 'deployment', 'app-store', 'publishing'],
        'duration': '36:40',
        'channelName': 'Flutter Deployment',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 9)),
        ),
      },
    ];

    for (var video in sampleVideos) {
      await _firestore.collection('videos').add(video);
    }

    // Reload after creating samples
    await loadVideos();
  }
}

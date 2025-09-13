class AppConstants {
  // App Info
  static const String appName = 'Video Learning Platform';
  static const String appVersion = '1.0.0';

  // Colors
  static const primaryColor = 0xFF2196F3;
  static const secondaryColor = 0xFF03DAC6;
  static const errorColor = 0xFFB00020;
  static const successColor = 0xFF4CAF50;

  // Dimensions
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String videosCollection = 'videos';
  static const String liveStatusCollection = 'live_status';
}

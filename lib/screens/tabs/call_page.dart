import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../utils/constants.dart';

final userId = Random().nextInt(9000);

class CallPage extends StatelessWidget {
  final String callId;
  const CallPage({super.key, required this.callId});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: AppConstants.appId, // Replace with your actual App ID
      appSign: AppConstants.appsign, // Replace with your actual App Sign
      callID: callId, // Unique call ID for the session
      userID: userId.toString(), // Unique user ID
      userName: 'UserName $userId', // User name
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}

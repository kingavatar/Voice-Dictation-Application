import 'package:flutter/material.dart';
import 'package:speechhelper/errorpage.dart';
import 'package:speechhelper/settingspage.dart';
import 'package:speechhelper/speechState.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) => SpeechScreen(
          title: 'Voice Dictation',
        ),
      );
    }
    else if( settings.name == '/settings'){
      return MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      );
    }
    return MaterialPageRoute(
        builder: (context) => ErrorScreen(),
      );
  }
}

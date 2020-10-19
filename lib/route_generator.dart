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
    } else if (settings.name == '/settings') {
      final AnimationController args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => SettingsScreen(controller: args,),
      );
    }
    return MaterialPageRoute(
      builder: (context) => ErrorScreen(),
    );
  }
}

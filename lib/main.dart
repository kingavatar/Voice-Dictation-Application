import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speechhelper/route_generator.dart';
import 'package:speechhelper/theme.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final currTheme = watch(themeNotifier);
      return MaterialApp(
        title: 'Voice Dictation Application',
        // debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: currTheme.currentTheme(),
        onGenerateRoute: RouteGenerator.generateRoute,
        // home: SpeechScreen(
        //   title: 'Voice Dictation',
        // ),
      );
    }
        // ),
        );
  }
}

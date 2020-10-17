import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.red,
  primaryColorBrightness: Brightness.light,
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  bottomSheetTheme: BottomSheetThemeData(modalBackgroundColor: Colors.white,modalElevation: 8),
  shadowColor: Colors.black,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  textTheme: TextTheme(
    // bodyText1: TextStyle(fontSize: 24, color: Colors.black54),
    headline1: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.w400),
    bodyText1: TextStyle(
      fontSize: 20.0,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
    button: TextStyle(color: Colors.grey[600], fontSize: 20),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
  ),
  accentIconTheme:  IconThemeData(color: Colors.grey[600]),
  primaryTextTheme: TextTheme(headline1: TextStyle(fontSize: 24, color: Colors.black54,fontWeight: FontWeight.w400)),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.grey[900],
  primaryColor: Colors.blue,
  backgroundColor: Colors.grey[900],
  shadowColor: Colors.white24,
  bottomSheetTheme: BottomSheetThemeData(modalBackgroundColor: Colors.grey[850],
  modalElevation: 8
  ),
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.w400),
    bodyText1: TextStyle(
      fontSize: 20.0,
      color: Colors.white60,
      fontWeight: FontWeight.w400,
    ),
    button: TextStyle(color: Colors.grey, fontSize: 22),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    // foregroundColor: Color(0xff000000),
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
  ),
  accentIconTheme:  IconThemeData(color: Colors.white),
  primaryTextTheme: TextTheme(headline1: TextStyle(fontSize: 24, color: Colors.white70,fontWeight: FontWeight.w400)),

);
final themeNotifier =
    ChangeNotifierProvider<MyThemeNotifier>((ref) => MyThemeNotifier());

class MyThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  
  Box<dynamic> _settings = Hive.box('settings');

  // Box<dynamic> get settings => _settings;

  set settings(Box<dynamic> settings) {
    _settings = settings;
  }
  // MyThemeNotifier({this.settings}) {
  //   isDarkMode = settings.get('isDarkMode', defaultValue: false);
  // }
  MyThemeNotifier(){
    isDarkMode = _settings.get('isDarkMode', defaultValue: false);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark
        ));
  }
  ThemeMode currentTheme() {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }


  void switchTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
    this._settings.put('isDarkMode', isDarkMode);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          // statusBarColor: isDarkMode ? darkTheme.backgroundColor.withOpacity(0.12) : Colors.white12,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark
          ));
  }
}

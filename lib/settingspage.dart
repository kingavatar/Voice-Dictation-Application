import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechhelper/nav_menu.dart';

class SettingsScreen extends StatelessWidget {
  final AnimationController controller;
  static const routeName = "/settings";

  const SettingsScreen({Key key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "No settings so far",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

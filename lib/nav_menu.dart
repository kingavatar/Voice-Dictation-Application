import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:speechhelper/settingspage.dart';

final isCollapsedProvider = StateProvider<bool>((ref) => true);
typedef ServerDetailsCallback = void Function(BuildContext context);

class NavMenu extends StatelessWidget {
  // const NavMenu({
  //   Key key,
  //   @required Animation<Offset> slideAnimation,
  //   @required Animation<double> menuScaleAnimation,
  //   @required this.context,
  // }) : _slideAnimation = slideAnimation, _menuScaleAnimation = menuScaleAnimation, super(key: key);

  final Animation<Offset> slideAnimation;
  final Animation<double> menuScaleAnimation;
  final BuildContext scaffoldContext;
  final AnimationController controller;
  final ServerDetailsCallback serverDetails;
  NavMenu({
    this.slideAnimation,
    this.menuScaleAnimation,
    this.scaffoldContext,
    this.controller,
    this.serverDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: menuScaleAnimation,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SizedBox(),
                ),
                FlatButton.icon(
                  icon: Icon(
                    Icons.article,
                    color: Theme.of(context).accentIconTheme.color,
                  ),
                  label: Text("Dashboard",
                      style: Theme.of(context).textTheme.button),
                  onPressed: () {
                    if (context.read(isCollapsedProvider).state)
                      controller.forward();
                    else
                      controller.reverse();

                    context.read(isCollapsedProvider).state =
                        !context.read(isCollapsedProvider).state;
                  },
                ),
                SizedBox(height: 10),
                FlatButton.icon(
                  icon: Icon(
                    Icons.dns,
                    color: Theme.of(context).accentIconTheme.color,
                  ),
                  label:
                      Text("Server", style: Theme.of(context).textTheme.button),
                  onPressed: () => serverDetails(context),
                ),
                SizedBox(height: 10),
                FlatButton.icon(
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).accentIconTheme.color,
                    ),
                    label: Text("Settings",
                        style: Theme.of(context).textTheme.button),
                    onPressed: () {
                      if (context.read(isCollapsedProvider).state)
                      controller.forward();
                    else
                      controller.reverse();

                    context.read(isCollapsedProvider).state =
                        !context.read(isCollapsedProvider).state;
                      Navigator.pushNamed(context, SettingsScreen.routeName,arguments: controller);
                    }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FlatButton.icon(
                        icon: Icon(
                          Icons.logout,
                          color: Theme.of(context).accentIconTheme.color,
                        ),
                        label: Text(
                          "Exit",
                          style: Theme.of(context).textTheme.button,
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                          exit(0);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

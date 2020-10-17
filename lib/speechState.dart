import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:speechhelper/client.dart';
import 'package:speechhelper/nav_menu.dart';
import 'package:speechhelper/server_textfield.dart';
import 'package:speechhelper/speechpage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeechScreen extends StatefulWidget {
  SpeechScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>
    with SingleTickerProviderStateMixin {
  DateTime currentBackPressTime;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  final TextEditingController ipAddrController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  BuildContext scaffoldContext;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    ipAddrController.dispose();
    portController.dispose();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: Scaffold(
        body: Builder(
          builder: (scaffoldContext) {
            this.scaffoldContext = scaffoldContext;
            return Stack(
              children: <Widget>[
                NavMenu(
                  slideAnimation: _slideAnimation,
                  menuScaleAnimation: _menuScaleAnimation,
                  scaffoldContext: scaffoldContext,
                  controller: _controller,
                  serverDetails: _serverDetails,
                ),
                SpeechPage(
                  duration: duration,
                  isCollapsed: true,
                  screenWidth: screenWidth,
                  scaleAnimation: _scaleAnimation,
                  controller: _controller,
                  serverDetails: _serverDetails,
                  scaffoldContext: scaffoldContext,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> _onbackpressed() {
    bool isCollapsed = context.read(isCollapsedProvider).state;
    if (!isCollapsed) {
      setState(() {
        if (isCollapsed)
          _controller.forward();
        else
          _controller.reverse();

        context.read(isCollapsedProvider).state =
            !context.read(isCollapsedProvider).state;
      });
      return Future.value(false);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press Again to Exit");
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  _serverDetails(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (BuildContext context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Server Details",
                            style:
                                Theme.of(context).primaryTextTheme.headline1)),
                    ServerTextField(
                      textController: ipAddrController,
                      isServer: true,
                    ),
                    ServerTextField(
                      textController: portController,
                      isServer: false,
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 45,
                      // elevation: 8,
                      // highlightElevation: 8,
                      // shape: ,
                      onPressed: () {
                        context.read(socketClientProvider).connect(
                            ipAddrController.text,
                            int.tryParse(portController.text),
                            scaffoldContext);
                        Navigator.pop(context);

                        bool isCollapsed =
                            context.read(isCollapsedProvider).state;
                        if (!isCollapsed) {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            context.read(isCollapsedProvider).state =
                                !context.read(isCollapsedProvider).state;
                          });
                        }
                      },
                      child: Text(
                        'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}

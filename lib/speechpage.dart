import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speechhelper/nav_menu.dart';
import 'package:speechhelper/theme.dart';
import 'package:speechhelper/client.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeechPage extends StatefulWidget {
  SpeechPage({
    this.duration,
    this.isCollapsed,
    this.screenWidth,
    this.scaleAnimation,
    this.controller,
    this.serverDetails,
    this.scaffoldContext,
  });

  final Duration duration;
  final bool isCollapsed;
  final double screenWidth;
  final Animation<double> scaleAnimation;
  final AnimationController controller;
  final ServerDetailsCallback serverDetails;
  final BuildContext scaffoldContext;

  @override
  _SpeechPageState createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage>
    with SingleTickerProviderStateMixin {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'location': HighlightedWord(
      onTap: () => print('Location'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'diagnosis': HighlightedWord(
      onTap: () => print('Diagnosis'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'name': HighlightedWord(
      onTap: () => print('name'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'report': HighlightedWord(
      onTap: () => print('Report'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  var _icon = Icons.wb_sunny_outlined;
  MyThemeNotifier _themeNotifier;
  stt.SpeechToText _speech;
  bool _isListening = false;
  // bool isCollapsed = true;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _themeNotifier = context.read(themeNotifier);
    _icon =
        _themeNotifier.isDarkMode ? Icons.nights_stay : Icons.wb_sunny_outlined;
    // isCollapsed = widget.isCollapsed;
    // isCollapsed = context.read(isCollapsedProvider).state;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      bool isCollapsed = watch(isCollapsedProvider).state;
      bool isConnected = watch(socketClientProvider.state);
      return AnimatedPositioned(
        duration: widget.duration,
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.4 * widget.screenWidth,
        right: isCollapsed ? 0 : -0.2 * widget.screenWidth,
        child: ScaleTransition(
          scale: widget.scaleAnimation,
          child: Material(
            animationDuration: widget.duration,
            borderRadius:
                isCollapsed ? null : BorderRadius.all(Radius.circular(40)),
            elevation: 9,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              padding: const EdgeInsets.all(30.0),
              // color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          icon: Icon(Icons.notes),
                          onPressed: () {
                            setState(() {
                              if (isCollapsed)
                                widget.controller.forward();
                              else
                                widget.controller.reverse();

                              // isCollapsed = !isCollapsed;
                              context.read(isCollapsedProvider).state =
                                  !context.read(isCollapsedProvider).state;
                            });
                          },
                        ),
                        // Consumer<MyThemeNotifier>(
                        // builder: (context, notifier, child) =>
                        Spacer(),
                        IconButton(
                            icon: Icon(_icon),
                            onPressed: () {
                              // notifier.switchTheme();
                              _themeNotifier.switchTheme();
                              setState(() {
                                if (_themeNotifier.currentTheme() ==
                                    ThemeMode.dark) {
                                  _icon = Icons.nights_stay;
                                } else {
                                  _icon = Icons.wb_sunny_outlined;
                                }
                              });
                            }),
                        IconButton(
                          icon: Icon(isConnected ? Icons.wifi : Icons.wifi_off),
                          onPressed: () {
                            if (!context
                                .read(socketClientProvider)
                                .reconnect(widget.scaffoldContext))
                              widget.serverDetails(context);
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 6,
                    borderOnForeground: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      child: Text(
                          'Confidence  :  ${(_confidence * 100.0).toStringAsFixed(1)}%',
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.headline1),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: TextHighlight(
                        text: _text,
                        words: _highlights,
                        textStyle: Theme.of(context).textTheme.bodyText1),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AvatarGlow(
                      animate: _isListening,
                      glowColor: Theme.of(context).primaryColor,
                      endRadius: 75.0,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,
                      child: FloatingActionButton(
                          onPressed: () => _listen(context),
                          child:
                              Icon(_isListening ? Icons.mic : Icons.mic_none)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _listen(BuildContext context) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == "notListening") {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          partialResults: false,
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.recognizedWords.length == 0) _text = "Listening...";
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
              if (val.recognizedWords.length != 0)
                context.read(socketClientProvider).sendData(_text, context);
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}

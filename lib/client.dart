import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';

final socketClientProvider =
    StateNotifierProvider<SocketClient>((ref) => SocketClient());

SnackBar snackBarType(String contentString, int type) {
  switch (type) {
    case 0:
      return SnackBar(
        content: Text(
          contentString,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      );
    case 1:
      return SnackBar(
        content: Text(
          contentString,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.amber,
      );
    case 2:
      return SnackBar(
        content: Text(
          contentString,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
    default:
  }
  return SnackBar(content: Text(contentString));
}

class SocketClient extends StateNotifier<bool> {
  SocketClient() : super(false);
  String ipAddr;
  bool _isConnected = false;
  Socket socket;
  bool get isConnected => _isConnected;
  int port;
  var sub;
  String serverResponse = "No Response Yet\n0.0";
  final Box<dynamic> box = Hive.box('settings');
  BuildContext scaffoldContext;
  Completer<String> _completer = new Completer<String>();
  void connect(String ipAddr, int port, BuildContext context) async {
    this.ipAddr = ipAddr;
    this.port = port;
    this.scaffoldContext = context;
    if (port == null ||
        ipAddr == "" ||
        ipAddr == " " ||
        port == 0 ||
        ipAddr == null) {
      ipAddr = box.get('ipAddr', defaultValue: "");
      port = box.get('port', defaultValue: 0);
      if (ipAddr == "" || port == 0) {
        Scaffold.of(scaffoldContext).hideCurrentSnackBar();
        Scaffold.of(context)
            .showSnackBar(snackBarType('Wrong Values, Please Try Again', 2));
        return;
      }
      Scaffold.of(scaffoldContext).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
          snackBarType('Using previous values of ipaddress and port', 1));
    } else {
      box.put('ipAddr', ipAddr);
      box.put('port', port);
    }
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBarType('Connecting...', 1));
    socket = await Socket.connect(ipAddr, port).catchError((e) {
      Scaffold.of(scaffoldContext)
          .showSnackBar(snackBarType('can\'t connect to server', 2));
      _isConnected = false;
      state = false;
      return;
    });
    if (socket == null) return;
    sub = socket.listen((event) {
      serverResponse = String.fromCharCodes(event).trim();
      print("Received "+serverResponse);
      state = true;
    }, onError: errorHandler, onDone: disconnect);
    _isConnected = true;
    state = true;
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(scaffoldContext).showSnackBar(snackBarType('Connected', 0));
    // socket.done.then((value) => disconnect);
    // sub.asFuture().then((_) => disconnect);
  }

  bool reconnect(BuildContext context) {
    if (!_isConnected) {
      ipAddr = box.get('ipAddr', defaultValue: "");
      port = box.get('port', defaultValue: 0);
      if (ipAddr == "" || port == 0) {
        return false;
      } else {
        connect(ipAddr, port, context);
        return true;
      }
    } else {
      disconnect();
      return true;
    }
  }

  void errorHandler(error) {
    _isConnected = false;
    Scaffold.of(scaffoldContext)
        .showSnackBar(snackBarType('Disconnected due to $error', 2));
  }

  void sendData(String data, BuildContext context) {
    this.scaffoldContext = context;
    if (!_isConnected) {
      Scaffold.of(scaffoldContext).hideCurrentSnackBar();
      Scaffold.of(scaffoldContext)
          .showSnackBar(snackBarType('Not connected', 1));
    } else
      try {
        // socket.done.then((value) => disconnect);
        // sub.asFuture().then((_) => disconnect);
        if (!_isConnected) return;
        socket.write(data);
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
          content: Text(
            "Receiving Model Output...",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.amber,
        ));
      } on SocketException catch (_) {
        Scaffold.of(scaffoldContext).hideCurrentSnackBar();
        Scaffold.of(scaffoldContext)
            .showSnackBar(snackBarType('Got Disconnected', 2));
        _isConnected = false;
        state = false;
      }
  }

  void disconnect() {
    if (_isConnected) {
      socket.destroy();
      Scaffold.of(scaffoldContext).hideCurrentSnackBar();
      Scaffold.of(scaffoldContext)
          .showSnackBar(snackBarType('Disconnected', 0));
      _isConnected = false;
      state = false;
    } else {
      Scaffold.of(scaffoldContext).hideCurrentSnackBar();
      Scaffold.of(scaffoldContext)
          .showSnackBar(snackBarType('Already Disconnected', 2));
    }
  }
}

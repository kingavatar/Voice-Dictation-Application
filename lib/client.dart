import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';

final socketClientProvider =
    StateNotifierProvider<SocketClient>((ref) => SocketClient());

class SocketClient extends StateNotifier<bool> {
  SocketClient() : super(false);
  String ipAddr;
  bool _isConnected = false;
  Socket socket;
  bool get isConnected => _isConnected;
  int port;
  var sub;
  final Box<dynamic> box = Hive.box('settings');
  BuildContext scaffoldContext;
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
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Wrong Values, Please Try Again'),
        ));
        return;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Using previous values of ipaddress and port')));
    } else {
      box.put('ipAddr', ipAddr);
      box.put('port', port);
    }
    socket = await Socket.connect(ipAddr, port).catchError((e) {
      Scaffold.of(scaffoldContext)
          .showSnackBar(SnackBar(content: Text('Can\'t connect to Server')));
      return;
    });
    if (socket == null) return;
    sub = socket.listen((event) {}, onError: errorHandler, onDone: () => disconnect);
    _isConnected = true;
    state = !state;
    Scaffold.of(scaffoldContext)
        .showSnackBar(SnackBar(content: Text('Connected')));
    socket.done.then((value) => disconnect);
    sub.asFuture().then((_) => disconnect);
  }

  bool reconnect(BuildContext context) {
    ipAddr = box.get('ipAddr', defaultValue: "");
    port = box.get('port', defaultValue: 0);
    if (ipAddr == "" || port == 0) {
      return false;
    } else {
      connect(ipAddr, port, context);
      return true;
    }
  }

  void errorHandler(error) {
    _isConnected = false;
    Scaffold.of(scaffoldContext)
        .showSnackBar(SnackBar(content: Text('Disconnected due to $error')));
  }

  void sendData(String data, BuildContext context) {
    this.scaffoldContext = context;
    if (!_isConnected)
      Scaffold.of(scaffoldContext)
          .showSnackBar(SnackBar(content: Text('Not connected')));
    else
      try {
        socket.done.then((value) => disconnect);
        sub.asFuture().then((_) => disconnect);
        if (!isConnected) return;
        socket.write(data);
      } on SocketException catch (_) {
        Scaffold.of(scaffoldContext)
            .showSnackBar(SnackBar(content: Text('Got Disconnected')));
        _isConnected = false;
        state = !state;
      }
  }

  void disconnect() {
    print("disconnected");
    if (_isConnected) {
      socket.close();
      Scaffold.of(scaffoldContext)
          .showSnackBar(SnackBar(content: Text('Disconnected')));
      _isConnected = false;
      state = !state;
    } else {
      Scaffold.of(scaffoldContext)
          .showSnackBar(SnackBar(content: Text('Already Disconnected')));
    }
  }
}

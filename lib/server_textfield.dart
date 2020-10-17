import 'package:flutter/material.dart';

class ServerTextField extends StatefulWidget {
  const ServerTextField({
    Key key,
    @required this.textController,
    this.isServer,
  }) : super(key: key);
  final bool isServer;
  final TextEditingController textController;

  @override
  _ServerTextFieldState createState() => _ServerTextFieldState();
}

class _ServerTextFieldState extends State<ServerTextField> {
  final hintText2 = 'Enter your port number';

  final hintText1 = 'Enter your Server ip Address';

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: widget.textController,
          decoration: InputDecoration.collapsed(
              hintText: widget.isServer ? hintText1 : hintText2,
              hintStyle: TextStyle(color: Colors.grey)),
          keyboardType:
              widget.isServer ? TextInputType.url : TextInputType.phone,
          textInputAction: TextInputAction.done,
        ));
  }
}

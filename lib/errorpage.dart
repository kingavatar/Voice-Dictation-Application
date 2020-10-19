import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "404 Not Found...",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w200,
                ),
          ),
          TextButton(
          child: Text("Go Back"),
          onPressed: ()=> Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

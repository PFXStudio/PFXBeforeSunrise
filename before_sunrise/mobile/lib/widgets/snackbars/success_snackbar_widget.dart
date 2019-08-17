import 'package:flutter/material.dart';

class SuccessSnackbarWidget {
  @override
  SuccessSnackbarWidget();

  void show(
      GlobalKey<ScaffoldState> key, String message, void Function() callback) {
    if (key == null) {
      return;
    }

    final maxDuration = 3;
    key.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          duration: Duration(seconds: maxDuration),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(message)),
              Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
      );

    Future.delayed(Duration(seconds: maxDuration), () {
      // deleayed code here
      key.currentState..hideCurrentSnackBar();
      if (callback == null) {
        return;
      }

      callback();
    });
  }
}

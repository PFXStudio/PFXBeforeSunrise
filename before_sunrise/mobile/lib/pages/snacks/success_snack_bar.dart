import 'package:before_sunrise/import.dart';
import 'package:flutter/material.dart';

class SuccessSnackBar {
  static final SuccessSnackBar _successSnarbarSingleton =
      new SuccessSnackBar._internal();
  factory SuccessSnackBar() {
    return _successSnarbarSingleton;
  }

  SuccessSnackBar._internal();
  GlobalKey<ScaffoldState> _scaffoldKey;

  void initialize(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
  }

  void show(String message, void Function() callback) {
    if (_scaffoldKey == null) {
      return;
    }

    final maxDuration = 2;
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          duration: Duration(seconds: maxDuration),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(message)),
              Icon(FontAwesomeIcons.checkCircle, color: Colors.green),
            ],
          ),
        ),
      );

    Future.delayed(Duration(seconds: maxDuration), () {
      // deleayed code here
      _scaffoldKey.currentState..hideCurrentSnackBar();
      if (callback == null) {
        return;
      }

      callback();
    });
  }
}

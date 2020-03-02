import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FailSnackBar {
  static final FailSnackBar _successSnarbarSingleton =
      new FailSnackBar._internal();
  factory FailSnackBar() {
    return _successSnarbarSingleton;
  }

  FailSnackBar._internal();
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
              Icon(FontAwesomeIcons.exclamationCircle, color: Colors.redAccent),
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

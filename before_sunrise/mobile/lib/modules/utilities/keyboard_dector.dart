import 'package:before_sunrise/import.dart';

class KeyboardDector {
  KeyboardDector._internal();
  static final KeyboardDector _instance = new KeyboardDector._internal();
  bool _isKeyboardVisible = false;

  factory KeyboardDector() {
    return _instance;
  }

  bool isKeyboardVisible() {
    return _isKeyboardVisible;
  }

  void initialize() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible) {
        _isKeyboardVisible = isVisible;
      },
    );
  }
}

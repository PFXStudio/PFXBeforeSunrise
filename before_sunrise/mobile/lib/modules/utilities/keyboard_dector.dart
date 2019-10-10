import 'package:before_sunrise/import.dart';

class KeyboardDector {
  KeyboardDector._internal();
  static final KeyboardDector _instance = new KeyboardDector._internal();
  bool _isKeyboardVisible = false;
  OverlayEntry overlayEntry;
  BuildContext context;

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
        if (context == null) {
          return;
        }

        if (isVisible == true) {
          showOverlay();
        } else {
          removeOverlay();
        }
      },
    );
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  showOverlay() {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: KeyboardItem());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}

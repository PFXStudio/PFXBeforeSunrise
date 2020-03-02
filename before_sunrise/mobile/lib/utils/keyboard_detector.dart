import 'package:before_sunrise/import.dart';

class KeyboardDetector {
  KeyboardDetector._internal();
  static final KeyboardDetector _instance = new KeyboardDetector._internal();
  bool _isKeyboardVisible = false;
  OverlayEntry overlayEntry;
  BuildContext context;
  double bottomHeight = 0;

  factory KeyboardDetector() {
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

  void setContext(BuildContext context, double bottomHeight) {
    print("=== keyboard setContext $bottomHeight");
    this.context = context;
    this.bottomHeight = bottomHeight;
  }

  showOverlay() {
    var size = this.context.size;
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + this.bottomHeight,
          right: 0.0,
          left: 0.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                FocusScope.of(this.context).requestFocus(new FocusNode());
              },
              child: Container(
                width: size.width,
                height: size.height,
                child: Text(
                  'Hide keyboard',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ));

      // KeyboardItem());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      bottomHeight = 0;
    }
  }
}

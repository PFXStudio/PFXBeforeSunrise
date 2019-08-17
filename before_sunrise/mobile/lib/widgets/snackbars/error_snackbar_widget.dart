import 'package:before_sunrise/import.dart';

class ErrorSnackbarWidget {
  @override
  ErrorSnackbarWidget();

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
          duration: Duration(seconds: maxDuration),
          backgroundColor: Colors.black87,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                message,
                style: TextStyle(color: Colors.white),
              )),
              Icon(Icons.error_outline, color: Colors.red),
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

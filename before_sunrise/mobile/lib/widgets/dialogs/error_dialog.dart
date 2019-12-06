import 'package:before_sunrise/import.dart';

class ErrorDialog extends StatelessWidget {
  final Widget child;
  final error;
  final Function onTap;

  ErrorDialog({Key key, this.child, this.error = "error", this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(error),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  colorBrightness: Brightness.dark,
                  child: Text(LocalizableLoader.of(context).text(this.error)),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    if (onTap != null) {
                      onTap();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

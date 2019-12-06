import 'package:before_sunrise/import.dart';

class BottomDialog extends StatefulWidget {
  @override
  _BottomDialogState createState() => _BottomDialogState();
  BottomDialog({this.cancelCallback, this.confirmCallback});
  VoidCallback cancelCallback;
  VoidCallback confirmCallback;
}

class _BottomDialogState extends State<BottomDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ButtonTheme.bar(
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                  child: Text(
                    LocalizableLoader.of(context).text("cancel"),
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    widget.cancelCallback();
                  }),
              FlatButton(
                  child: Text(
                    LocalizableLoader.of(context).text("done"),
                    style: TextStyle(color: MainTheme.enabledButtonColor),
                  ),
                  onPressed: () {
                    widget.confirmCallback();
                  }),
            ],
          ),
        ));
  }
}

import 'package:before_sunrise/import.dart';

class DialogBottomWidget extends StatefulWidget {
  @override
  _DialogBottomWidgetState createState() => _DialogBottomWidgetState();
  DialogBottomWidget({this.cancelCallback, this.confirmCallback});
  VoidCallback cancelCallback;
  VoidCallback confirmCallback;
}

class _DialogBottomWidgetState extends State<DialogBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ButtonTheme.bar(
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                  child: Text(
                    LocalizableLoader.of(context).text("cancel_button"),
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    widget.cancelCallback();
                  }),
              FlatButton(
                  child: Text(
                    LocalizableLoader.of(context).text("done_button"),
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

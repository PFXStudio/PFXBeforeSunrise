import 'package:before_sunrise/import.dart';

class LoadingContents extends StatefulWidget {
  @override
  _LoadingContentsState createState() => _LoadingContentsState();
}

class _LoadingContentsState extends State<LoadingContents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 50.0),
        PlatformAdaptiveProgressIndicator(),
      ],
    );
  }
}

typedef LoadingFailContentsCallback = void Function();

class LoadingFailContents extends StatefulWidget {
  LoadingFailContents({this.callback});
  @override
  _LoadingFailContentsState createState() => _LoadingFailContentsState();

  LoadingFailContentsCallback callback;
}

class _LoadingFailContentsState extends State<LoadingFailContents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 50.0),
        FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(FontAwesomeIcons.sync),
              Text('refresh'),
            ],
          ),
          onPressed: () {
            if (widget.callback == null) {
              return;
            }

            widget.callback();
          },
        ),
        Text('Sorry, you are yet to subscribe to a post :('),
      ],
    );
  }
}

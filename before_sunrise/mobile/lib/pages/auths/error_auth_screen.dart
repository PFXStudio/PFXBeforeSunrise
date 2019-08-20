import 'package:before_sunrise/import.dart';

class ErrorAuthScreen extends StatelessWidget {
  ErrorAuthScreen({@required this.context, @required this.callback});

  final BuildContext context;
  String message;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    String errorMessage = message ?? "Error!!";
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        decoration: new BoxDecoration(
          gradient: MainTheme.primaryLinearGradient,
        ),
        height: _deviceHeight,
        width: _deviceWidth,
        padding: EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          Flexible(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(height: 30.0),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildErrorTitle(context),
                      SizedBox(height: 30.0),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      FlatIconTextButton(
                        iconData: FontAwesomeIcons.angleDoubleDown,
                        text: "Retry",
                        onPressed: () {
                          callback();
                        },
                      )
                    ],
                  ),
                )
              ]))
        ]));
  }
}

Widget _buildErrorTitle(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          Text(
            LocalizableLoader.of(context).text("app_title"),
            style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 10.0),
      Text(
        'Sign in to continue to app',
        style: TextStyle(
            color: Colors.white70, fontSize: 20.0, fontWeight: FontWeight.bold),
      )
    ],
  );
}

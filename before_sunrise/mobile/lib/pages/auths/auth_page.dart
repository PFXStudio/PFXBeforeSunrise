import 'package:before_sunrise/import.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    FailSnackbar().initialize(_scaffoldKey);
    SuccessSnackbar().initialize(_scaffoldKey);

    var _authBloc = new AuthBloc();
    return new Scaffold(
      key: _scaffoldKey,
      body: new AuthScreen(authBloc: _authBloc),
    );
  }
}

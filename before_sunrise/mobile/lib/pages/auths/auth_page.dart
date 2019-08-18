import 'package:before_sunrise/import.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    var _authBloc = new AuthBloc();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Auth"),
      ),
      body: new AuthScreen(authBloc: _authBloc),
    );
  }
}

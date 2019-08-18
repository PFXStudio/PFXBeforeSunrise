import 'package:before_sunrise/import.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key key,
    @required AuthBloc authBloc,
  })  : _authBloc = authBloc,
        super(key: key);

  final AuthBloc _authBloc;

  @override
  AuthScreenState createState() {
    return new AuthScreenState(_authBloc);
  }
}

class AuthScreenState extends State<AuthScreen> {
  final AuthBloc _authBloc;
  AuthScreenState(this._authBloc);

  @override
  void initState() {
    super.initState();
    // this._authBloc.dispatch(LoadAuthEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        bloc: widget._authBloc,
        builder: (
          BuildContext context,
          AuthState currentState,
        ) {
          if (currentState is UnAuthState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorAuthState) {
            return new Container(
                child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error'),
            ));
          }
          return new Container(
              child: new Center(
            child: new Text("В разработке"),
          ));
        });
  }
}

import 'package:before_sunrise/import.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  AuthBloc _authBloc = AuthBloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    initializeDeviceSize(context);
    return Scaffold(
        key: _scaffoldKey,
        body: BlocListener(
            bloc: _authBloc,
            listener: (context, state) async {
              if (state is UnAuthState) {
                Navigator.pushReplacementNamed(
                  context,
                  AuthScreen.routeName,
                );

                return;
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
                bloc: _authBloc,
                builder: (
                  BuildContext context,
                  AuthState currentState,
                ) {
                  return Drawer(
                      child: Center(
                          child: Column(
                    children: <Widget>[
                      RaisedButton(
                          child: Text('account1'),
                          onPressed: () {
                            var authInfo = AuthInfo();
                            authInfo.userID = "yo8FFTVESHROr9KkbXbwezHv57E2111";
                            authInfo.nickname = "조국";
                            authInfo.description = "살려줘";
                            authInfo.phoneNumber = "+821056897311";
                            authInfo.imageUrl = "";

                            AuthBloc()
                                .dispatch(TestAuthEvent(authInfo: authInfo));
                          } // _authBloc.signout(),
                          ),
                      RaisedButton(
                          child: Text('account2'),
                          onPressed: () {} // _authBloc.signout(),
                          ),
                      RaisedButton(
                          child: Text('account3'),
                          onPressed: () {} // _authBloc.signout(),
                          ),
                      RaisedButton(
                          child: Text('account4'),
                          onPressed: () {} // _authBloc.signout(),
                          ),
                      RaisedButton(
                          child: Text('Logout'),
                          onPressed: () {
                            AuthBloc().dispatch(SignoutEvent());
                          } // _authBloc.signout(),
                          ),
                    ],
                  )));
                })));
  }
}

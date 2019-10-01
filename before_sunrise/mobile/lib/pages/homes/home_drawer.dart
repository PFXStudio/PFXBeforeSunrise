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
                    child: RaisedButton(
                        child: Text('Logout'),
                        onPressed: () {
                          AuthBloc().dispatch(SignoutEvent());
                        } // _authBloc.signout(),
                        ),
                  ));
                })));
  }
}

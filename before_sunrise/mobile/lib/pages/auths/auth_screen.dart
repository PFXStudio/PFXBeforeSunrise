import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/auths/error_auth_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth";
  const AuthScreen({
    Key key,
  }) : super(key: key);

  @override
  AuthScreenState createState() {
    return new AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  final AuthBloc _authBloc = AuthBloc();
  String _verificationID = "";

  ErrorAuthScreen _errorAuthScreen;
  UnAuthScreen _unAuthScreen;
  VerifyAuthScreen _verifyAuthScreen;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    this._authBloc.dispatch(LoadAuthEvent());
    SuccessSnackBar().initialize(_scaffoldKey);
    FailSnackBar().initialize(_scaffoldKey);

    _errorAuthScreen = ErrorAuthScreen(
        context: context,
        callback: () {
          this._authBloc.dispatch(LoadAuthEvent());
        });
    _unAuthScreen = UnAuthScreen(
        context: context,
        callback: (isoCode, phoneNumber) {
          this._authBloc.dispatch(CreateVerifyCodeEvent(
              phoneNumber: phoneNumber,
              countryIsoCode: isoCode,
              callback: (verificationID) {
                _verifyAuthScreen.phoneNumber = phoneNumber;
                if (verificationID == null) {
                  _authBloc.dispatch(
                      ErrorAuthEvent(errorCode: "error_wrong_verification"));
                  return;
                }

                _verificationID = verificationID;
              }));
        });
    _verifyAuthScreen = VerifyAuthScreen(
        context: context,
        callback: (verifyCode) {
          if (_verificationID == null || _verificationID.length <= 0) {
            FailSnackBar().show("error_wrong_verification", () {});
            return;
          }

          this._authBloc.dispatch(VerifyCodeEvent(
              verificationCode: verifyCode, verificationID: _verificationID));
        });
  }

  @override
  void dispose() {
    SuccessSnackBar().initialize(null);
    FailSnackBar().initialize(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDeviceSize(context);
    return Scaffold(
        key: _scaffoldKey,
        body: BlocListener(
            bloc: _authBloc,
            listener: (context, state) async {
              if (state is InAuthState) {
                String userID = await _authBloc.getUserID();
                Navigator.pushReplacementNamed(
                    context, ProfileStepPage.routeName,
                    arguments: userID);

                return;
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
                bloc: _authBloc,
                builder: (
                  BuildContext context,
                  AuthState currentState,
                ) {
                  if (currentState is VerifyAuthState) {
                    return _verifyAuthScreen;
                  }

                  if (currentState is ErrorAuthState) {
                    _errorAuthScreen.message = currentState.errorMessage;
                    return _errorAuthScreen;
                  }

                  return _unAuthScreen;
                })));
  }
}

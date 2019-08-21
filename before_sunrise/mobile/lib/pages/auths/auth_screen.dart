import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/auths/error_auth_screen.dart';

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
  String _verificationID = "";

  ErrorAuthScreen _errorAuthScreen;
  UnAuthScreen _unAuthScreen;
  VerifyAuthScreen _verifyAuthScreen;
  @override
  void initState() {
    super.initState();
    this._authBloc.dispatch(LoadAuthEvent());

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
                  _authBloc.dispatch(ErrorAuthEvent(errorCode: "E12334"));
                  return;
                }

                _verificationID = verificationID;
              }));
        });
    _verifyAuthScreen = VerifyAuthScreen(
        context: context,
        callback: (verifyCode) {
          if (_verificationID == null || _verificationID.length <= 0) {
            FailSnackbar().show("E22223", () {});
            return;
          }

          this._authBloc.dispatch(VerifyCodeEvent(
              verificationCode: verifyCode, verificationID: _verificationID));
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget._authBloc,
        listener: (context, state) async {
          if (state is InAuthState) {
            String userID = await _authBloc.getUserID();
            Navigator.pushReplacementNamed(context, ProfileInputPage.routeName,
                arguments: userID);

            return;
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
            bloc: widget._authBloc,
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
            }));
  }
}

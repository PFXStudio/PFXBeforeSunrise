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

  final _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedCountryCode = "+82";
  String _countryIsoCode = "KR";

  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    this._authBloc.dispatch(LoadAuthEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget._authBloc,
        listener: (context, state) {},
        child: BlocBuilder<AuthBloc, AuthState>(
            bloc: widget._authBloc,
            builder: (
              BuildContext context,
              AuthState currentState,
            ) {
              if (currentState is VerifyAuthState) {
                return _buildVerifyAuthStateScreen();
              }

              if (currentState is InAuthState) {
                Navigator.pushNamed(context, ProfileInputPage.routeName);
                return Container();
              }
              if (currentState is ErrorAuthState) {
                return _buildErrorAuthState(currentState.errorMessage);
              }

              return _buildUnAuthStateScreen();
            }));
  }

  Widget _buildUnAuthStateScreen() {
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLoginFormTitle(),
                      SizedBox(height: 30.0),
                      Text(
                        'Please select your country code and enter your phone number (+xxx xxxx xxxx xxx)',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      _buildVerificationFormFields(),
                      SizedBox(height: 30.0),
                      _buildVerificationControlButton(),
                    ],
                  ),
                )
              ]))
        ]));
  }

  Future<void> _touchedCreateVerifyCodeButton() async {
    if (_selectedCountryCode == null || _selectedCountryCode.isEmpty) {
      FailSnackbar().show("E11111", () {});
      return;
    }

    if (!_formKey.currentState.validate()) return;

    final String phoneNumberWithCode =
        '$_selectedCountryCode${_phoneNumberController.text}';

    this._authBloc.dispatch(CreateVerifyCodeEvent(
        phoneNumber: phoneNumberWithCode,
        countryIsoCode: _countryIsoCode,
        callback: (result) {
          if (result == null) {
            _authBloc.dispatch(ErrorAuthEvent(errorCode: "E122334"));
            return;
          }
        }));
  }

  Widget _buildLoginFormTitle() {
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
              color: Colors.white70,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _buildVerificationFormFields() {
    return Row(
      children: <Widget>[
        CountryCodePicker(
          onChanged: (CountryCode countryCode) {
            _countryIsoCode = countryCode.code;
            _selectedCountryCode = countryCode.toString();
          },
          initialSelection: '+82',
          favorite: ['+82'],
          showCountryOnly: false,
          textStyle: TextStyle(color: Colors.white, fontSize: 28.0),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _phoneNumberController,
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
            decoration:
                InputDecoration(contentPadding: EdgeInsets.only(bottom: 5.0)),
            validator: (String value) {
              return value.isEmpty ? 'Enter a valid phone number!' : null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationControlButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () {
          _touchedCreateVerifyCodeButton();
        },
        child: Container(
          height: 50.0,
          width: 200.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.white70),
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_right,
                size: 30.0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyAuthStateScreen() {
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildVerifyFormTitle(),
                      SizedBox(height: 30.0),
                      _loginFormSubTitle(),
                      SizedBox(height: 10.0),
                      _buildLoginFormField(),
                      SizedBox(height: 20.0),
                      _buidRequestNewCodeControlButton(authBloc: _authBloc),
                      SizedBox(height: 30.0),
                      _buildVerifyCodeControlButton(authBloc: _authBloc),
                    ],
                  ),
                )
              ]))
        ]));
  }

  Future<void> _touchedVerifyButton() async {
    if (!_formKey.currentState.validate()) {
      FailSnackbar().show("E22222", () {});
      return;
    }

    this._authBloc.dispatch(
        VerifyCodeEvent(verificationCode: _verificationCodeController.text));
  }

  Widget _buildVerifyFormTitle() {
    final String phoneNumberWithCode =
        '$_selectedCountryCode${_phoneNumberController.text}';
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
        RichText(
          text: TextSpan(
            text: 'Please enter the verification code we sent to your phone ',
            style: TextStyle(
              color: Colors.white70,
              // fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '$phoneNumberWithCode ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'to continue.',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginFormSubTitle() {
    return Text(
      'Code Verification',
      style: TextStyle(
          color: Colors.white70, fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLoginFormField() {
    return TextFormField(
      maxLength: 6,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: _verificationCodeController,
      style: TextStyle(
          color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white10,
        counterText: '',
        border: InputBorder.none,
      ),
      validator: (String value) {
        return value.length < 6
            ? 'Please enter the verification code sent to your number!'
            : null;
      },
    );
  }

  Widget _buidRequestNewCodeControlButton({@required AuthBloc authBloc}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          this._authBloc.dispatch(LoadAuthEvent());
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Text(
            'Request a new code',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyCodeControlButton({@required AuthBloc authBloc}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () {
          _touchedVerifyButton();
        },
        child: Container(
          height: 50.0,
          width: 200.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.white70),
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'VERIFY CODE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_right,
                size: 30.0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _touchedNewCodeButton() {}

  Widget _buildErrorAuthState(String message) {
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLoginFormTitle(),
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
                          this._authBloc.dispatch(LoadAuthEvent());
                        },
                      )
                    ],
                  ),
                )
              ]))
        ]));
  }
}

import 'package:before_sunrise/import.dart';

typedef VerifyAuthScreenCallback = void Function(String verifyCode);

class VerifyAuthScreen extends StatelessWidget {
  VerifyAuthScreen({
    @required this.context,
    @required this.callback,
  });
  final GlobalKey<FormState> _verifyFormKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  final BuildContext context;
  final VerifyAuthScreenCallback callback;
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = kDeviceHeight;
    final double _deviceWidth = kDeviceWidth;
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
                  key: _verifyFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildVerifyFormTitle(),
                      SizedBox(height: 30.0),
                      _loginFormSubTitle(),
                      SizedBox(height: 10.0),
                      _buildLoginFormField(),
                      SizedBox(height: 20.0),
                      _buidRequestNewCodeControlButton(),
                      SizedBox(height: 30.0),
                      _buildVerifyCodeControlButton(),
                    ],
                  ),
                )
              ]))
        ]));
  }

  Future<void> _touchedVerifyButton() async {
    if (!_verifyFormKey.currentState.validate()) {
      FailSnackbar().show("error_wrong_verify_number", () {});
      return;
    }

    callback(_verificationCodeController.text);
  }

  Widget _buildVerifyFormTitle() {
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
                text: '$phoneNumber ',
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

  Widget _buidRequestNewCodeControlButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // this._authBloc.dispatch(LoadAuthEvent());
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

  Widget _buildVerifyCodeControlButton() {
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
                FontAwesomeIcons.angleRight,
                size: 30.0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

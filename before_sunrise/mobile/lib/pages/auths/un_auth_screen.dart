import 'package:before_sunrise/import.dart';

typedef UnAuthScreenCallback = void Function(
    String isoCode, String phoneNumber);

class UnAuthScreen extends StatelessWidget {
  UnAuthScreen({@required this.context, @required this.callback});
  final _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey<FormState>();

  final BuildContext context;
  final UnAuthScreenCallback callback;
  String _selectedCountryCode = "+82";
  String _countryIsoCode = "KR";

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          gradient: MainTheme.primaryLinearGradient,
        ),
        height: kDeviceHeight,
        width: kDeviceWidth,
        padding: EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          Flexible(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(height: 30.0),
                Form(
                  key: _phoneNumberFormKey,
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
      FailSnackbar().show("error_country_code", () {});
      return;
    }

    if (!_phoneNumberFormKey.currentState.validate()) {
      FailSnackbar().show("error_wrong_phone_number", () {});
      return;
    }

    final String phoneNumberWithCode =
        '$_selectedCountryCode${_phoneNumberController.text}';
    callback(_countryIsoCode, phoneNumberWithCode);
  }

  Widget _buildLoginFormTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              LocalizableLoader.of(context).text("app_name"),
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

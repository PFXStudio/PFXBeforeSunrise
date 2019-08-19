import 'package:core/import.dart';

typedef CreateVerifyCodeCallback = void Function(String code);

abstract class IClient {
  Future<bool> isSingedIn();
  Future<String> getUserID();
  Future<String> getPhoneNumber();
  Future<bool> requestVerifyCode(
      {@required String phoneNumber,
      @required String countryIsoCode,
      @required CreateVerifyCodeCallback callback});
  Future<String> requestAuth({
    @required String verificationCode,
    @required String verificationID,
  });
  Future<void> requestSignout();
}

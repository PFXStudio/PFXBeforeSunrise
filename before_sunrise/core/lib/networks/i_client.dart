import 'package:core/import.dart';

abstract class IClient {
  Future<bool> isSingedIn();
  Future<String> getUserID();
  Future<String> getPhoneNumber();
  Future<String> requestVerifyCode(
      {@required String phoneNumber, @required String countryIsoCode});
  Future<String> requestAuth(
      {@required String verificationCode, @required String verificationId});
  Future<void> requestSignout();
}

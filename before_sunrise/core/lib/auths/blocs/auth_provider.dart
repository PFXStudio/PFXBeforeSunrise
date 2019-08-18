import 'package:core/import.dart';

// 변수 접근 방지용으로 인터페이스 관리 하려는 듯
abstract class IAuthProvider {
  Future<bool> isSingedIn();
  Future<String> getUserID();
  Future<String> getPhoneNumber();
  Future<String> requestVerifyCode(
      {@required String phoneNumber, @required String countryIsoCode});
  Future<String> requestAuth(
      {@required String verificationCode, @required String verificationId});
  Future<void> requestSignout();
}

class AuthProvider implements IAuthProvider {
  IClient _client;

  AuthProvider() {
    _client = Injector().currentClient;
  }

  @override
  Future<String> getUserID() {
    return _client.getUserID();
  }

  Future<String> getPhoneNumber() {
    return _client.getPhoneNumber();
  }

  @override
  Future<bool> isSingedIn() {
    return _client.isSingedIn();
  }

  @override
  Future<String> requestAuth({String verificationCode, String verificationId}) {
    return _client.requestAuth(
        verificationCode: verificationCode, verificationId: verificationId);
  }

  @override
  Future<void> requestSignout() {
    return _client.requestSignout();
  }

  @override
  Future<String> requestVerifyCode(
      {String phoneNumber, String countryIsoCode}) {
    return _client.requestVerifyCode(
        phoneNumber: phoneNumber, countryIsoCode: countryIsoCode);
  }
}

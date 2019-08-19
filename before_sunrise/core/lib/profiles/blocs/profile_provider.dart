import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IProfileProvider {
  Future<bool> isSingedIn();
  Future<String> getUserID();
  Future<String> getPhoneNumber();
  Future<bool> requestVerifyCode(
      {@required String phoneNumber, @required String countryIsoCode});
  Future<String> requestAuth({@required String verificationCode});
  Future<void> requestSignout();
}

class ProfileProvider implements IProfileProvider {
  IClient _client;

  ProfileProvider() {
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
  Future<String> requestAuth({String verificationCode}) {
    return _client.requestAuth(verificationCode: verificationCode);
  }

  @override
  Future<void> requestSignout() {
    return _client.requestSignout();
  }

  @override
  Future<bool> requestVerifyCode(
      {String phoneNumber, String countryIsoCode}) async {
    return await _client.requestVerifyCode(
        phoneNumber: phoneNumber, countryIsoCode: countryIsoCode);
  }
}

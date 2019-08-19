import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IAuthProvider {
  Future<bool> isSingedIn();
  Future<String> getUserID();
  Future<String> getPhoneNumber();
  Future<bool> requestVerifyCode(
      {@required String phoneNumber,
      @required String countryIsoCode,
      @required CreateVerifyCodeCallback callback});
  Future<String> requestAuth(
      {@required String verificationCode, @required String verificationID});
  Future<void> requestSignout();
}

class AuthProvider implements IAuthProvider {
  AuthRepository _authRepository;

  AuthProvider() {
    _authRepository = AuthRepository();
  }

  @override
  Future<String> getUserID() {
    return _authRepository.getUserID();
  }

  Future<String> getPhoneNumber() {
    return _authRepository.getPhoneNumber();
  }

  @override
  Future<bool> isSingedIn() {
    return _authRepository.isSingedIn();
  }

  @override
  Future<String> requestAuth({String verificationCode, String verificationID}) {
    return _authRepository.requestAuth(
        verificationCode: verificationCode, verificationID: verificationID);
  }

  @override
  Future<void> requestSignout() {
    return _authRepository.requestSignout();
  }

  @override
  Future<bool> requestVerifyCode(
      {String phoneNumber,
      String countryIsoCode,
      @required CreateVerifyCodeCallback callback}) async {
    return await _authRepository.requestVerifyCode(
        phoneNumber: phoneNumber,
        countryIsoCode: countryIsoCode,
        callback: callback);
  }
}

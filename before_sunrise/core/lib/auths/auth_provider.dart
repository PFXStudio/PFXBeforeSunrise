import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IAuthProvider {
  Future<void> initializeTestAuth(AuthInfo authInfo);
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
  AuthInfo _testAuthInfo;

  AuthProvider() {
    _authRepository = AuthRepository();
  }

  Future<void> initializeTestAuth(AuthInfo authInfo) {
    _testAuthInfo = authInfo;
  }

  @override
  Future<String> getUserID() {
    if (_testAuthInfo != null) {
      return Future<String>.value(_testAuthInfo.userID);
    }

    return _authRepository.getUserID();
  }

  Future<String> getPhoneNumber() {
    if (_testAuthInfo != null) {
      return Future<String>.value(_testAuthInfo.phoneNumber);
    }

    return _authRepository.getPhoneNumber();
  }

  @override
  Future<bool> isSingedIn() {
    if (_testAuthInfo != null) {
      return Future<bool>.value(true);
    }

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

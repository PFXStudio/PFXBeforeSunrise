import 'package:core/import.dart';
import 'package:core/networks/i_client.dart';

class FirebaseClient implements IClient {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  Future<bool> isSingedIn() async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    return currentUser != null ? true : false;
  }

  Future<String> getUserID() async {
    return (await _firebaseAuth.currentUser()).uid ?? '';
  }

  Future<String> getPhoneNumber() async {
    return (await _firebaseAuth.currentUser()).phoneNumber ?? '';
  }

  Future<bool> requestVerifyCode(
      {@required String phoneNumber,
      @required String countryIsoCode,
      @required CreateVerifyCodeCallback callback}) async {
    try {
      if (!await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: phoneNumber, isoCode: countryIsoCode)) {
        throw Exception('Invalid phone number!');
      }

      _verificationId = "";

      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        _firebaseAuth.signInWithCredential(phoneAuthCredential);

        print('Received phone auth credential: $phoneAuthCredential');
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
        callback(null);
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        print('Please check your phone for the verification code.');

        _verificationId = verificationId;
        print('PhoneCodeSent $_verificationId');
        callback(_verificationId);
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
        callback(null);
      };

      print(phoneNumber);

      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 0),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

      return true;
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<String> requestAuth({@required String verificationCode}) async {
    try {
      if (_verificationId == null || _verificationId.length <= 0) {
        throw Exception('Invalid _verificationId!');
      }

      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: verificationCode,
      );

      final FirebaseUser user =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);

      return user != null ? user.uid : "";
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<void> requestSignout() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }
}

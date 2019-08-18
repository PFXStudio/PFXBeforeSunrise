import 'package:core/import.dart';

@immutable
abstract class AuthEvent {
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc});
}

class CreateVerifyCodeEvent extends AuthEvent {
  CreateVerifyCodeEvent(
      {@required this.phoneNumber, @required this.countryIsoCode});
  // VerifyCodeEvent({@required this.phoneNumber, @required this.countryIsoCode});
  String toString() => 'CreateVerifyCodeEvent';
  final IAuthProvider _authProvider = AuthProvider();
  final String phoneNumber;
  final String countryIsoCode;

  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    try {
      String result = await _authProvider.requestVerifyCode(
          phoneNumber: phoneNumber, countryIsoCode: countryIsoCode);
      if (result == null || result.length <= 0) {
        return UnAuthState();
      }

      return VerifyAuthState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return ErrorAuthState(_?.toString());
    }
  }
}

class VerifyCodeEvent extends AuthEvent {
  VerifyCodeEvent({@required this.verificationCode, this.verificationId});
  @override
  String toString() => 'VerifyCodeEvent';
  final IAuthProvider _authProvider = AuthProvider();
  final String verificationCode;
  final String verificationId;

  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    try {
      String result = await _authProvider.requestAuth(
          verificationCode: verificationCode, verificationId: verificationId);

      if (result == null || result.length <= 0) {
        return ErrorAuthState("");
      }

      return InAuthState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return ErrorAuthState(_?.toString());
    }
  }
}

class SignoutEvent extends AuthEvent {
  final IAuthProvider _authProvider = AuthProvider();
  String toString() => 'SignoutEvent';

  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    try {
      await _authProvider.requestSignout();
      return UnAuthState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return ErrorAuthState(_?.toString());
    }
  }
}

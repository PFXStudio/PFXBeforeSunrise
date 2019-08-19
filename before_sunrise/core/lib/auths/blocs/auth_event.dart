import 'package:core/import.dart';

@immutable
abstract class AuthEvent {
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc});
}

class LoadAuthEvent extends AuthEvent {
  String toString() => 'LoadAuthEvent';
  final IAuthProvider _authProvider = AuthProvider();

  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    try {
      bool result = await _authProvider.isSingedIn();
      if (result == true) {
        return InAuthState();
      }

      return UnAuthState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return ErrorAuthState(_?.toString());
    }
  }
}

class CreateVerifyCodeEvent extends AuthEvent {
  CreateVerifyCodeEvent(
      {@required this.phoneNumber,
      @required this.countryIsoCode,
      @required this.callback});
  // VerifyCodeEvent({@required this.phoneNumber, @required this.countryIsoCode});
  String toString() => 'CreateVerifyCodeEvent';
  final IAuthProvider _authProvider = AuthProvider();
  final String phoneNumber;
  final String countryIsoCode;
  final CreateVerifyCodeCallback callback;

  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    try {
      bool result = await _authProvider.requestVerifyCode(
          phoneNumber: phoneNumber,
          countryIsoCode: countryIsoCode,
          callback: callback);
      if (result == false) {
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
  VerifyCodeEvent(
      {@required this.verificationCode, @required this.verificationID});
  @override
  String toString() => 'VerifyCodeEvent';
  final IAuthProvider _authProvider = AuthProvider();
  final String verificationCode;
  final String verificationID;

  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    try {
      String result = await _authProvider.requestAuth(
          verificationCode: verificationCode, verificationID: verificationID);

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

class ErrorAuthEvent extends AuthEvent {
  final IAuthProvider _authProvider = AuthProvider();
  ErrorAuthEvent({@required this.errorCode});
  final String errorCode;
  String toString() => 'ErrorEvent';

  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    try {
      return ErrorAuthState(errorCode);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return ErrorAuthState(_?.toString());
    }
  }
}

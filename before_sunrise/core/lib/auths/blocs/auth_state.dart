import 'package:core/import.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([Iterable props]) : super(props);

  /// Copy object for use in action
  AuthState getStateCopy();
}

/// 인증이 필요함(기본)
class UnAuthState extends AuthState {
  @override
  String toString() => 'UnAuthState';

  @override
  AuthState getStateCopy() {
    return UnAuthState();
  }
}

/// 인증 됨
class InAuthState extends AuthState {
  @override
  String toString() => 'InAuthState';

  @override
  AuthState getStateCopy() {
    return InAuthState();
  }
}

/// 인증코드 상태
class VerifyAuthState extends AuthState {
  @override
  String toString() => 'VerifyAuthState';

  @override
  AuthState getStateCopy() {
    return VerifyAuthState();
  }
}

/// 인증 중
class TryAuthState extends AuthState {
  @override
  String toString() => 'TryAuthState';

  @override
  AuthState getStateCopy() {
    return TryAuthState();
  }
}

class ErrorAuthState extends AuthState {
  final String errorMessage;

  ErrorAuthState(this.errorMessage);

  @override
  String toString() => 'ErrorAuthState';

  @override
  AuthState getStateCopy() {
    return ErrorAuthState(this.errorMessage);
  }
}

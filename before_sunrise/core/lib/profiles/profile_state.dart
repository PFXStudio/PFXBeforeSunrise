import 'package:core/import.dart';

@immutable
abstract class ProfileState extends Equatable {
  ProfileState([Iterable props]) : super(props);

  /// Copy object for use in action
  ProfileState getStateCopy();
}

/// 프로필 불러오기
class LoadProfileState extends ProfileState {
  @override
  String toString() => 'UnProfileState';

  @override
  ProfileState getStateCopy() {
    return UnProfileState();
  }
}

/// 프로필이 없는 상태(기본)
class UnProfileState extends ProfileState {
  @override
  String toString() => 'UnProfileState';

  @override
  ProfileState getStateCopy() {
    return UnProfileState();
  }
}

/// 프로필 생성 완료
class InProfileState extends ProfileState {
  InProfileState({@required this.profile});
  @override
  String toString() => 'InProfileState';
  Profile profile;

  @override
  ProfileState getStateCopy() {
    return InProfileState(profile: profile);
  }
}

// 프로필 에러
class ErrorProfileState extends ProfileState {
  final String errorMessage;

  ErrorProfileState(this.errorMessage);

  @override
  String toString() => 'ErrorProfileState';

  @override
  ProfileState getStateCopy() {
    return ErrorProfileState(this.errorMessage);
  }
}

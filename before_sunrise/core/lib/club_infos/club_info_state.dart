import 'package:core/import.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ClubInfoState extends Equatable {
  ClubInfoState([Iterable props]) : super(props);

  /// Copy object for use in action
  ClubInfoState getStateCopy();
}

class UnClubInfoState extends ClubInfoState {
  @override
  String toString() => 'UnClubInfoState';

  @override
  ClubInfoState getStateCopy() {
    return UnClubInfoState();
  }
}

/// 정보 요청
class FetchingClubInfoState extends ClubInfoState {
  @override
  String toString() => 'FetchingClubInfoState';

  @override
  ClubInfoState getStateCopy() {
    return FetchingClubInfoState();
  }
}

/// 정보를 불러 온 상태
class FetchedClubInfoState extends ClubInfoState {
  FetchedClubInfoState({this.clubInfos});
  @override
  String toString() => 'FetchedClubInfoState';
  final List<ClubInfo> clubInfos;

  @override
  ClubInfoState getStateCopy() {
    return FetchedClubInfoState(clubInfos: this.clubInfos);
  }
}

class EmptyClubInfoState extends ClubInfoState {
  EmptyClubInfoState();
  @override
  String toString() => 'EmptyClubInfoState';

  @override
  ClubInfoState getStateCopy() {
    return EmptyClubInfoState();
  }
}

class IdleClubInfoState extends ClubInfoState {
  IdleClubInfoState();
  @override
  String toString() => 'IdleClubInfoState';

  @override
  ClubInfoState getStateCopy() {
    return IdleClubInfoState();
  }
}

class ErrorClubInfoState extends ClubInfoState {
  final String errorMessage;

  ErrorClubInfoState(this.errorMessage);

  @override
  String toString() => 'ErrorClubInfoState';

  @override
  ClubInfoState getStateCopy() {
    return ErrorClubInfoState(this.errorMessage);
  }
}

class SuccessClubInfoState extends ClubInfoState {
  SuccessClubInfoState({this.clubInfo, this.isUpdate});

  @override
  String toString() => 'SuccessClubInfoState';
  final ClubInfo clubInfo;
  final bool isUpdate;

  @override
  ClubInfoState getStateCopy() {
    return SuccessClubInfoState(clubInfo: clubInfo, isUpdate: isUpdate);
  }
}

class SuccessRemoveClubInfoState extends ClubInfoState {
  SuccessRemoveClubInfoState({this.clubInfo});

  @override
  String toString() => 'SuccessRemoveClubInfoState';
  final ClubInfo clubInfo;

  @override
  ClubInfoState getStateCopy() {
    return SuccessRemoveClubInfoState();
  }
}

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ClubInfoState extends Equatable {
  ClubInfoState([Iterable props]) : super(props);

  /// Copy object for use in action
  ClubInfoState getStateCopy();
}

/// UnInitialized
class UnClubInfoState extends ClubInfoState {
  @override
  String toString() => 'UnClubInfoState';

  @override
  ClubInfoState getStateCopy() {
    return UnClubInfoState();
  }
}

/// Initialized
class InClubInfoState extends ClubInfoState {
  @override
  String toString() => 'InClubInfoState';

  @override
  ClubInfoState getStateCopy() {
    return InClubInfoState();
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

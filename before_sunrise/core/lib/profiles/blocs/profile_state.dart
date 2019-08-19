import 'package:core/import.dart';

@immutable
abstract class ProfileState extends Equatable {
  ProfileState([Iterable props]) : super(props);

  /// Copy object for use in action
  ProfileState getStateCopy();
}

/// UnInitialized
class UnProfileState extends ProfileState {
  @override
  String toString() => 'UnProfileState';

  @override
  ProfileState getStateCopy() {
    return UnProfileState();
  }
}

/// Initialized
class InProfileState extends ProfileState {
  @override
  String toString() => 'InProfileState';

  @override
  ProfileState getStateCopy() {
    return InProfileState();
  }
}

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

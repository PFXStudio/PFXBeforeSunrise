import 'package:before_sunrise/import.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState([Iterable props]) : super(props);

  /// Copy object for use in action
  HomeState getStateCopy();
}

/// UnInitialized
class UnHomeState extends HomeState {
  @override
  String toString() => 'UnHomeState';

  @override
  HomeState getStateCopy() {
    return UnHomeState();
  }
}

/// Initialized
class InHomeState extends HomeState {
  @override
  String toString() => 'InHomeState';

  @override
  HomeState getStateCopy() {
    return InHomeState();
  }
}

/// PostTab
class PostTabState extends HomeState {
  @override
  String toString() => 'PostTabState';

  @override
  HomeState getStateCopy() {
    return PostTabState();
  }
}

/// InfoTab
class InfoTabState extends HomeState {
  @override
  String toString() => 'InfoTabState';

  @override
  HomeState getStateCopy() {
    return InfoTabState();
  }
}

/// ProfileTab
class ProfileTabState extends HomeState {
  @override
  String toString() => 'ProfileTabState';

  @override
  HomeState getStateCopy() {
    return ProfileTabState();
  }
}

class ErrorHomeState extends HomeState {
  final String errorMessage;

  ErrorHomeState(this.errorMessage);

  @override
  String toString() => 'ErrorHomeState';

  @override
  HomeState getStateCopy() {
    return ErrorHomeState(this.errorMessage);
  }
}

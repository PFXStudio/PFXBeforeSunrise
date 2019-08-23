import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InfoState extends Equatable {
  InfoState([Iterable props]) : super(props);

  /// Copy object for use in action
  InfoState getStateCopy();
}

/// UnInitialized
class UnInfoState extends InfoState {
  @override
  String toString() => 'UnInfoState';

  @override
  InfoState getStateCopy() {
    return UnInfoState();
  }
}

/// Initialized
class InInfoState extends InfoState {
  @override
  String toString() => 'InInfoState';

  @override
  InfoState getStateCopy() {
    return InInfoState();
  }
}

class ErrorInfoState extends InfoState {
  final String errorMessage;

  ErrorInfoState(this.errorMessage);
  
  @override
  String toString() => 'ErrorInfoState';

  @override
  InfoState getStateCopy() {
    return ErrorInfoState(this.errorMessage);
  }
}

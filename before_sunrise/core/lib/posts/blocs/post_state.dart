import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PostState extends Equatable {
  PostState([Iterable props]) : super(props);

  /// Copy object for use in action
  PostState getStateCopy();
}

/// UnInitialized
class UnPostState extends PostState {
  @override
  String toString() => 'UnPostState';

  @override
  PostState getStateCopy() {
    return UnPostState();
  }
}

/// Initialized
class InPostState extends PostState {
  @override
  String toString() => 'InPostState';

  @override
  PostState getStateCopy() {
    return InPostState();
  }
}

class ErrorPostState extends PostState {
  final String errorMessage;

  ErrorPostState(this.errorMessage);
  
  @override
  String toString() => 'ErrorPostState';

  @override
  PostState getStateCopy() {
    return ErrorPostState(this.errorMessage);
  }
}

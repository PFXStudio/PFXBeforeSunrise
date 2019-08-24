import 'package:core/import.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShardsState extends Equatable {
  ShardsState([Iterable props]) : super(props);

  /// Copy object for use in action
  ShardsState getStateCopy();
}

class UnShardsState extends ShardsState {
  @override
  String toString() => 'UnShardsState';

  @override
  ShardsState getStateCopy() {
    return UnShardsState();
  }
}

class ErrorShardsState extends ShardsState {
  final String errorMessage;

  ErrorShardsState(this.errorMessage);

  @override
  String toString() => 'ErrorProfileState';

  @override
  ShardsState getStateCopy() {
    return ErrorShardsState(this.errorMessage);
  }
}

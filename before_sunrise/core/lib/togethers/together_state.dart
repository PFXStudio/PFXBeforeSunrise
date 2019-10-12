import 'package:core/import.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TogetherState extends Equatable {
  TogetherState([Iterable props]) : super(props);

  /// Copy object for use in action
  TogetherState getStateCopy();
}

class UnTogetherState extends TogetherState {
  @override
  String toString() => 'UnTogetherState';

  @override
  TogetherState getStateCopy() {
    return UnTogetherState();
  }
}

/// 정보 요청
class FetchingTogetherState extends TogetherState {
  @override
  String toString() => 'FetchingTogetherState';

  @override
  TogetherState getStateCopy() {
    return FetchingTogetherState();
  }
}

/// 정보를 불러 온 상태
class FetchedTogetherState extends TogetherState {
  FetchedTogetherState({this.togetherCollection});
  @override
  String toString() => 'FetchedTogetherState';
  final TogetherCollection togetherCollection;

  @override
  TogetherState getStateCopy() {
    return FetchedTogetherState(togetherCollection: this.togetherCollection);
  }
}

class EmptyTogetherState extends TogetherState {
  EmptyTogetherState({this.togetherCollection});
  @override
  String toString() => 'EmptyTogetherState';
  final TogetherCollection togetherCollection;

  @override
  TogetherState getStateCopy() {
    return EmptyTogetherState();
  }
}

class IdleTogetherState extends TogetherState {
  IdleTogetherState();
  @override
  String toString() => 'IdleTogetherState';

  @override
  TogetherState getStateCopy() {
    return IdleTogetherState();
  }
}

class ErrorTogetherState extends TogetherState {
  final String errorMessage;

  ErrorTogetherState(this.errorMessage);

  @override
  String toString() => 'ErrorTogetherState';

  @override
  TogetherState getStateCopy() {
    return ErrorTogetherState(this.errorMessage);
  }
}

class SuccessTogetherState extends TogetherState {
  SuccessTogetherState({this.together});

  @override
  String toString() => 'SuccessTogetherState';
  final Together together;

  @override
  TogetherState getStateCopy() {
    return SuccessTogetherState(together: together);
  }
}

class SuccessRemoveTogetherState extends TogetherState {
  SuccessRemoveTogetherState();

  @override
  String toString() => 'SuccessRemoveTogetherState';

  @override
  TogetherState getStateCopy() {
    return SuccessRemoveTogetherState();
  }
}

class EditTogetherState extends TogetherState {
  EditTogetherState();

  @override
  String toString() => 'EditTogetherState';

  @override
  TogetherState getStateCopy() {
    return EditTogetherState();
  }
}

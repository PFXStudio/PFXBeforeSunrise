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
  FetchedTogetherState({this.posts});
  @override
  String toString() => 'FetchedTogetherState';
  final List<Post> posts;

  @override
  TogetherState getStateCopy() {
    return FetchedTogetherState(posts: this.posts);
  }
}

class EmptyTogetherState extends TogetherState {
  EmptyTogetherState();
  @override
  String toString() => 'EmptyTogetherState';

  @override
  TogetherState getStateCopy() {
    return EmptyTogetherState();
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
  SuccessTogetherState();

  @override
  String toString() => 'SuccessTogetherState';

  @override
  TogetherState getStateCopy() {
    return SuccessTogetherState();
  }
}

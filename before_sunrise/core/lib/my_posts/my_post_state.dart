import 'package:core/import.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyPostState extends Equatable {
  MyPostState([Iterable props]) : super(props);

  /// Copy object for use in action
  MyPostState getStateCopy();
}

class UnMyPostState extends MyPostState {
  @override
  String toString() => 'UnMyPostState';

  @override
  MyPostState getStateCopy() {
    return UnMyPostState();
  }
}

/// 정보 요청
class FetchingMyPostState extends MyPostState {
  @override
  String toString() => 'FetchingMyPostState';

  @override
  MyPostState getStateCopy() {
    return FetchingMyPostState();
  }
}

/// 정보를 불러 온 상태
class FetchedMyPostState extends MyPostState {
  FetchedMyPostState({this.posts});
  @override
  String toString() => 'FetchedMyPostState';
  final List<Post> posts;

  @override
  MyPostState getStateCopy() {
    return FetchedMyPostState(posts: this.posts);
  }
}

class EmptyMyPostState extends MyPostState {
  EmptyMyPostState();
  @override
  String toString() => 'EmptyMyPostState';

  @override
  MyPostState getStateCopy() {
    return EmptyMyPostState();
  }
}

class ErrorMyPostState extends MyPostState {
  final String errorMessage;

  ErrorMyPostState(this.errorMessage);

  @override
  String toString() => 'ErrorMyPostState';

  @override
  MyPostState getStateCopy() {
    return ErrorMyPostState(this.errorMessage);
  }
}

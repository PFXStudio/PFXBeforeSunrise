import 'package:core/import.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PostState extends Equatable {
  PostState([Iterable props]) : super(props);

  /// Copy object for use in action
  PostState getStateCopy();
}

/// 정보 요청
class UnPostState extends PostState {
  @override
  String toString() => 'UnPostState';

  @override
  PostState getStateCopy() {
    return UnPostState();
  }
}

/// 정보를 불러 온 상태
class InPostState extends PostState {
  InPostState({this.posts});
  @override
  String toString() => 'InPostState';
  final List<Post> posts;

  @override
  PostState getStateCopy() {
    return InPostState(posts: this.posts);
  }
}

class IdlePostState extends PostState {
  IdlePostState();
  @override
  String toString() => 'IdlePostState';

  @override
  PostState getStateCopy() {
    return IdlePostState();
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

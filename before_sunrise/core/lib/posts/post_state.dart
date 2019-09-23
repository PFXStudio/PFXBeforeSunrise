import 'package:core/import.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PostState extends Equatable {
  PostState([Iterable props]) : super(props);

  /// Copy object for use in action
  PostState getStateCopy();
}

class UnPostState extends PostState {
  @override
  String toString() => 'UnPostState';

  @override
  PostState getStateCopy() {
    return UnPostState();
  }
}

/// 정보 요청
class FetchingPostState extends PostState {
  @override
  String toString() => 'FetchingPostState';

  @override
  PostState getStateCopy() {
    return FetchingPostState();
  }
}

/// 정보를 불러 온 상태
class FetchedPostState extends PostState {
  FetchedPostState({this.posts});
  @override
  String toString() => 'FetchedPostState';
  final List<Post> posts;

  @override
  PostState getStateCopy() {
    return FetchedPostState(posts: this.posts);
  }
}

class EmptyPostState extends PostState {
  EmptyPostState();
  @override
  String toString() => 'EmptyPostState';

  @override
  PostState getStateCopy() {
    return EmptyPostState();
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

class SuccessPostState extends PostState {
  SuccessPostState({this.post});

  @override
  String toString() => 'SuccessPostState';
  final Post post;

  @override
  PostState getStateCopy() {
    return SuccessPostState();
  }
}

class SuccessRemovePostState extends PostState {
  SuccessRemovePostState();

  @override
  String toString() => 'SuccessRemovePostState';

  @override
  PostState getStateCopy() {
    return SuccessRemovePostState();
  }
}

import 'package:core/import.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CommentState extends Equatable {
  CommentState([Iterable props]) : super(props);

  /// Copy object for use in action
  CommentState getStateCopy();
}

class UnCommentState extends CommentState {
  @override
  String toString() => 'UnCommentState';

  @override
  CommentState getStateCopy() {
    return UnCommentState();
  }
}

/// 정보 요청
class FetchingCommentState extends CommentState {
  @override
  String toString() => 'FetchingCommentState';

  @override
  CommentState getStateCopy() {
    return FetchingCommentState();
  }
}

/// 정보를 불러 온 상태
class FetchedCommentState extends CommentState {
  FetchedCommentState({this.comments});
  @override
  String toString() => 'FetchedCommentState';
  final List<Comment> comments;

  @override
  CommentState getStateCopy() {
    return FetchedCommentState(comments: this.comments);
  }
}

class IdleCommentState extends CommentState {
  @override
  String toString() => 'IdleCommentState';

  @override
  CommentState getStateCopy() {
    return IdleCommentState();
  }
}

class EmptyCommentState extends CommentState {
  EmptyCommentState();
  @override
  String toString() => 'EmptyCommentState';

  @override
  CommentState getStateCopy() {
    return EmptyCommentState();
  }
}

class ErrorCommentState extends CommentState {
  final String errorMessage;

  ErrorCommentState(this.errorMessage);

  @override
  String toString() => 'ErrorCommentState';

  @override
  CommentState getStateCopy() {
    return ErrorCommentState(this.errorMessage);
  }
}

class SuccessCommentState extends CommentState {
  SuccessCommentState();

  @override
  String toString() => 'SuccessCommentState';

  @override
  CommentState getStateCopy() {
    return SuccessCommentState();
  }
}

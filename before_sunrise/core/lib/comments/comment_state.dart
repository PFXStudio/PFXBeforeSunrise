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
  SuccessCommentState({this.isIncrease = false, this.comment});

  @override
  String toString() => 'SuccessCommentState';
  final Comment comment;
  final bool isIncrease;

  @override
  CommentState getStateCopy() {
    return SuccessCommentState(isIncrease: isIncrease, comment: comment);
  }
}

class EditCommentState extends CommentState {
  EditCommentState({@required this.comment});

  final Comment comment;

  @override
  String toString() => 'EditCommentState';

  @override
  CommentState getStateCopy() {
    return EditCommentState(comment: comment);
  }
}

class ReplyCommentState extends CommentState {
  ReplyCommentState({@required this.parentComment});

  final Comment parentComment;

  @override
  String toString() => 'ReplyCommentState';

  @override
  CommentState getStateCopy() {
    return ReplyCommentState(parentComment: parentComment);
  }
}

class MoveCommentState extends CommentState {
  MoveCommentState({this.commentID});
  @override
  String toString() => 'MoveCommentState';

  final String commentID;

  @override
  CommentState getStateCopy() {
    return MoveCommentState();
  }
}

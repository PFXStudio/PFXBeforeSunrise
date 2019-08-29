import 'package:core/import.dart';

@immutable
abstract class ShardsEvent {
  Future<ShardsState> applyAsync({ShardsState currentState, ShardsBloc bloc});
  final ShardsRepository _shardsRepository = new ShardsRepository();
}

class IncreasePostLikeCountEvent extends ShardsEvent {
  IncreasePostLikeCountEvent({@required this.postID});
  @override
  String toString() => 'IncreasePostLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increasePostLikeCount(postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class DecreasePostLikeCountEvent extends ShardsEvent {
  DecreasePostLikeCountEvent({@required this.postID});
  @override
  String toString() => 'DecreasePostLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.decreasePostLikeCount(postID: postID);
      return UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class IncreaseCommentLikeCountEvent extends ShardsEvent {
  IncreaseCommentLikeCountEvent({@required this.commentID});
  @override
  String toString() => 'IncreaseCommentLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String commentID;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increaseCommentLikeCount(commentID: commentID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class DecreaseCommentLikeCountEvent extends ShardsEvent {
  DecreaseCommentLikeCountEvent({@required this.commentID});
  @override
  String toString() => 'DecreaseCommentLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String commentID;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.decreaseCommentLikeCount(commentID: commentID);
      return UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

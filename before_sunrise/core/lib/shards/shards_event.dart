import 'package:core/import.dart';

@immutable
abstract class ShardsEvent {
  Future<ShardsState> applyAsync({ShardsState currentState, ShardsBloc bloc});
}

class RemovePostLikeCountEvent extends ShardsEvent {
  RemovePostLikeCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'RemovePostLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      await _shardsProvider.removePostLikeCount(postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class IncreasePostLikeCountEvent extends ShardsEvent {
  IncreasePostLikeCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreasePostLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increasePostLikeCount(category: category, postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class DecreasePostLikeCountEvent extends ShardsEvent {
  DecreasePostLikeCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'DecreasePostLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.decreasePostLikeCount(category: category, postID: postID);
      return UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class RemoveCommentCountEvent extends ShardsEvent {
  RemoveCommentCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'RemoveCommentCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.removeCommentCount(postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class IncreaseCommentCountEvent extends ShardsEvent {
  IncreaseCommentCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreaseCommentCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increaseCommentCount(category: category, postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class DecreaseCommentCountEvent extends ShardsEvent {
  DecreaseCommentCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'DecreaseCommentCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.decreaseCommentCount(category: category, postID: postID);
      return UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class RemoveReportCountEvent extends ShardsEvent {
  RemoveReportCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'RemoveReportCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.removeReportCount(postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class IncreaseReportCountEvent extends ShardsEvent {
  IncreaseReportCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreaseReportCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increaseReportCount(category: category, postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class DecreaseReportCountEvent extends ShardsEvent {
  DecreaseReportCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'DecreaseReportCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.decreaseReportCount(category: category, postID: postID);
      return UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class RemoveViewCountEvent extends ShardsEvent {
  RemoveViewCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'RemoveViewCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.removeViewCount(postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class IncreaseViewCountEvent extends ShardsEvent {
  IncreaseViewCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreaseViewCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String postID;
  final String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increaseViewCount(category: category, postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

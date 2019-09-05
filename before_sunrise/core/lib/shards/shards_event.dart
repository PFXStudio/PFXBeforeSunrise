import 'package:core/import.dart';

@immutable
abstract class ShardsEvent {
  Future<ShardsState> applyAsync({ShardsState currentState, ShardsBloc bloc});
}

class IncreasePostLikeCountEvent extends ShardsEvent {
  IncreasePostLikeCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreasePostLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;
  String category;

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
  String postID;
  String category;

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

class IncreaseCommentCountEvent extends ShardsEvent {
  IncreaseCommentCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreaseCommentCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;
  String category;

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
  String postID;
  String category;

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

class IncreaseReporterCountEvent extends ShardsEvent {
  IncreaseReporterCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreaseReporterCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;
  String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increaseReporterCount(category: category, postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class DecreaseReporterCountEvent extends ShardsEvent {
  DecreaseReporterCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'DecreaseReporterCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;
  String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.decreaseReporterCount(category: category, postID: postID);
      return UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class IncreaseViewerCountEvent extends ShardsEvent {
  IncreaseViewerCountEvent({@required this.category, @required this.postID});
  @override
  String toString() => 'IncreaseViewerCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;
  String category;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increaseViewerCount(category: category, postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

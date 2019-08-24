import 'package:core/import.dart';

@immutable
abstract class ShardsEvent {
  Future<ShardsState> applyAsync({ShardsState currentState, ShardsBloc bloc});
  final ShardsRepository _shardsRepository = new ShardsRepository();
}

class IncreaseLikeCountEvent extends ShardsEvent {
  IncreaseLikeCountEvent({@required this.postID});
  @override
  String toString() => 'IncreaseLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.increaseLikeCount(postID: postID);
      return new UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

class DecreaseLikeCountEvent extends ShardsEvent {
  DecreaseLikeCountEvent({@required this.postID});
  @override
  String toString() => 'DecreaseLikeCountEvent';
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;

  @override
  Future<ShardsState> applyAsync(
      {ShardsState currentState, ShardsBloc bloc}) async {
    try {
      _shardsProvider.decreaseLikeCount(postID: postID);
      return UnShardsState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShardsState(_?.toString());
    }
  }
}

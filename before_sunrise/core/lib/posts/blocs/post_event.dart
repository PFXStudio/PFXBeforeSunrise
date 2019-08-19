import 'package:core/import.dart';

@immutable
abstract class PostEvent {
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc});
  final PostRepository _postRepository = new PostRepository();
}

class LoadPostEvent extends PostEvent {
  @override
  String toString() => 'LoadPostEvent';

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      await Future.delayed(new Duration(seconds: 2));
      return new InPostState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

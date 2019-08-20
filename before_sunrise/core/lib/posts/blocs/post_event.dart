import 'package:core/import.dart';

@immutable
abstract class PostEvent {
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc});
  final PostRepository _postRepository = new PostRepository();
}

class LoadPostEvent extends PostEvent {
  LoadPostEvent({@required this.post});
  @override
  String toString() => 'LoadPostEvent';
  final IPostProvider _postProvider = PostProvider();
  Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      QuerySnapshot snapshot =
          await _postProvider.fetchPosts(lastVisiblePost: post);
      List<Post> posts = List<Post>();
      if (snapshot == null) {
        return InPostState(posts: posts);
      }
      if (snapshot.documents.length <= 0) {
        return InPostState(posts: posts);
      }

      for (var document in snapshot.documents) {
        Post post = Post();
        post.initialize(document);
        posts.add(post);
      }

      return new InPostState(posts: posts);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

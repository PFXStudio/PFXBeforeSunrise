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
  final IProfileProvider _profileProvider = ProfileProvider();
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
        DocumentSnapshot snapshot =
            await _profileProvider.fetchProfile(userID: post.userID);
        Profile profile = Profile();
        profile.initialize(snapshot);
        post.profile = profile;
        posts.add(post);
      }

      return new InPostState(posts: posts);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class CreatePostEvent extends PostEvent {
  CreatePostEvent({@required this.post})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreatePostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  FieldValue _firestoreTimestamp;

  Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      post.userID = await _authProvider.getUserID();
      post.created = _firestoreTimestamp;
      post.lastUpdate = _firestoreTimestamp;
      DocumentReference reference =
          await _postProvider.createPost(data: post.data());
      if (reference == null) {
        return ErrorPostState("error");
      }

      return new IdlePostState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

import 'package:core/import.dart';
import 'package:core/my_posts/my_post_state.dart';

@immutable
abstract class MyPostEvent {
  Future<MyPostState> applyAsync({MyPostState currentState, MyPostBloc bloc});
}

class LoadMyPostEvent extends MyPostEvent {
  LoadMyPostEvent({@required this.category, @required this.post});
  @override
  String toString() => 'LoadMyPostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  Post post;
  String category;

  @override
  Future<MyPostState> applyAsync(
      {MyPostState currentState, MyPostBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      QuerySnapshot snapshot = await _postProvider.fetchProfilePosts(
          category: category, userID: userID, lastVisiblePost: post);
      List<Post> posts = List<Post>();
      if (snapshot == null) {
        return EmptyMyPostState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyMyPostState();
      }

      DocumentSnapshot profileSnapshot =
          await _profileProvider.fetchProfile(userID: userID);
      Profile profile = Profile();
      profile.initialize(profileSnapshot);
      for (var document in snapshot.documents) {
        Post post = Post();
        post.initialize(document);
        post.profile = profile;

        post.isLike = await _postProvider.isLike(
            postID: post.postID, userID: userID, category: post.category);
        DocumentSnapshot shardsSnapshot =
            await _shardsProvider.postLikeCount(postID: post.postID);
        if (shardsSnapshot != null && shardsSnapshot.data != null) {
          post.likeCount = shardsSnapshot.data["count"];
        }

        posts.add(post);
      }

      return new FetchedMyPostState(posts: posts);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorMyPostState(_?.toString());
    }
  }
}

class ToggleLikeMyPostEvent extends MyPostEvent {
  ToggleLikeMyPostEvent(
      {@required this.category, @required this.postID, this.isLike});
  @override
  String toString() => 'ToggleLikeMyPostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  String postID;
  bool isLike;
  String category;

  @override
  Future<MyPostState> applyAsync(
      {MyPostState currentState, MyPostBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isLike == true) {
        await _postProvider.addToLike(
            postID: postID, userID: userID, category: category);
        await _shardsProvider.increasePostLikeCount(
            postID: postID, category: category);
      } else {
        await _postProvider.removeFromLike(
            postID: postID, userID: userID, category: category);
        await _shardsProvider.decreasePostLikeCount(
            postID: postID, category: category);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorMyPostState(_?.toString());
    }
  }
}

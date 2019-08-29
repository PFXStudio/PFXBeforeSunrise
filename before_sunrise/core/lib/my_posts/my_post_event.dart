import 'package:core/import.dart';
import 'package:core/my_posts/my_post_state.dart';

@immutable
abstract class MyPostEvent {
  Future<MyPostState> applyAsync({MyPostState currentState, MyPostBloc bloc});
}

class LoadMyPostEvent extends MyPostEvent {
  LoadMyPostEvent({@required this.post});
  @override
  String toString() => 'LoadMyPostEvent';
  final IMyPostProvider _postProvider = MyPostProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  Post post;

  @override
  Future<MyPostState> applyAsync(
      {MyPostState currentState, MyPostBloc bloc}) async {
    try {
      QuerySnapshot snapshot =
          await _postProvider.fetchMyPosts(lastVisibleMyPost: post);
      List<Post> posts = List<Post>();
      if (snapshot == null) {
        return EmptyMyPostState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyMyPostState();
      }

      String userID = await _authProvider.getUserID();
      for (var document in snapshot.documents) {
        Post post = Post();
        post.initialize(document);
        DocumentSnapshot snapshot =
            await _profileProvider.fetchProfile(userID: post.userID);
        Profile profile = Profile();
        profile.initialize(snapshot);
        post.profile = profile;

        post.isLiked =
            await _postProvider.isLiked(postID: post.postID, userID: userID);
        DocumentSnapshot shardsSnapshot =
            await _shardsProvider.postLikedCount(postID: post.postID);
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
  ToggleLikeMyPostEvent({@required this.postID, this.isLike});
  @override
  String toString() => 'ToggleLikeMyPostEvent';
  final IMyPostProvider _postProvider = MyPostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  String postID;
  bool isLike;

  @override
  Future<MyPostState> applyAsync(
      {MyPostState currentState, MyPostBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isLike == true) {
        await _postProvider.addToLike(postID: postID, userID: userID);
        await _shardsProvider.increasePostLikeCount(postID: postID);
      } else {
        await _postProvider.removeFromLike(postID: postID, userID: userID);
        await _shardsProvider.decreasePostLikeCount(postID: postID);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorMyPostState(_?.toString());
    }
  }
}

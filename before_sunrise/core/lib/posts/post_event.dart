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
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      QuerySnapshot snapshot =
          await _postProvider.fetchPosts(lastVisiblePost: post);
      List<Post> posts = List<Post>();
      if (snapshot == null) {
        return EmptyPostState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyPostState();
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
            await _shardsProvider.likedCount(postID: post.postID);
        if (shardsSnapshot != null && shardsSnapshot.data != null) {
          post.likeCount = shardsSnapshot.data["count"];
        }

        posts.add(post);
      }

      return new FetchedPostState(posts: posts);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class ToggleLikePostEvent extends PostEvent {
  ToggleLikePostEvent({@required this.postID, this.isLike});
  @override
  String toString() => 'ToggleLikePostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  String postID;
  bool isLike;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isLike == true) {
        await _postProvider.addToLike(postID: postID, userID: userID);
        await _shardsProvider.increaseLikeCount(postID: postID);
      } else {
        await _postProvider.removeFromLike(postID: postID, userID: userID);
        await _shardsProvider.decreaseLikeCount(postID: postID);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class CreatePostEvent extends PostEvent {
  CreatePostEvent({@required this.post, @required this.byteDatas})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreatePostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  FieldValue _firestoreTimestamp;
  List<ByteData> byteDatas;

  Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      List<String> imageUrls = List<String>();
      if (byteDatas != null) {
        final String fileLocation = '$userID/posts';

        imageUrls = await _imageProvider.uploadPostImages(
            fileLocation: fileLocation, byteDatas: byteDatas);
      }
      post.userID = userID;
      post.created = _firestoreTimestamp;
      post.lastUpdate = _firestoreTimestamp;
      post.imageUrls = imageUrls;
      DocumentReference reference =
          await _postProvider.createPost(data: post.data());
      if (reference == null) {
        return ErrorPostState("error");
      }

      return new SuccessPostState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

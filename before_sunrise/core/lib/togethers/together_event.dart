import 'package:core/import.dart';

@immutable
abstract class TogetherEvent {
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc});
}

class LoadTogetherEvent extends TogetherEvent {
  LoadTogetherEvent({@required this.post});
  @override
  String toString() => 'LoadTogetherEvent';
  final ITogetherProvider _postProvider = TogetherProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  Post post;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      QuerySnapshot snapshot =
          await _postProvider.fetchTogethers(lastVisibleTogether: post);
      List<Post> posts = List<Post>();
      if (snapshot == null) {
        return EmptyTogetherState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyTogetherState();
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

      return new FetchedTogetherState(posts: posts);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}

class ToggleLikeTogetherEvent extends TogetherEvent {
  ToggleLikeTogetherEvent({@required this.postID, this.isLike});
  @override
  String toString() => 'ToggleLikeTogetherEvent';
  final ITogetherProvider _postProvider = TogetherProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  String postID;
  bool isLike;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
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
      return new ErrorTogetherState(_?.toString());
    }
  }
}

class CreateTogetherEvent extends TogetherEvent {
  CreateTogetherEvent({@required this.post, @required this.byteDatas})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreateTogetherEvent';
  final ITogetherProvider _postProvider = TogetherProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  FieldValue _firestoreTimestamp;
  List<ByteData> byteDatas;

  Post post;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
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
          await _postProvider.createTogether(data: post.data());
      if (reference == null) {
        return ErrorTogetherState("error");
      }

      return new SuccessTogetherState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}

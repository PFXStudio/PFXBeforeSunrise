import 'package:core/import.dart';

@immutable
abstract class CommentEvent {
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc});
}

class LoadCommentEvent extends CommentEvent {
  LoadCommentEvent({@required this.postID, @required this.comment});
  @override
  String toString() => 'LoadCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  String postID;
  Comment comment;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      QuerySnapshot snapshot = await _commentProvider.fetchComment(
          postID: postID, lastVisibleComment: comment);
      List<Comment> comments = List<Comment>();
      if (snapshot == null) {
        return EmptyCommentState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyCommentState();
      }

      for (var document in snapshot.documents) {
        Comment infoComment = Comment();
        infoComment.initialize(document);
        DocumentSnapshot snapshot =
            await _profileProvider.fetchProfile(userID: infoComment.userID);
        Profile profile = Profile();
        profile.initialize(snapshot);
        infoComment.profile = profile;

        // infoComment.isLiked = await _commentProvider.isLiked(
        //     postID: postID, commentID: infoComment.commentID);
        // DocumentSnapshot shardsSnapshot = await _shardsProvider
        //     .commentLikedCount(commentID: infoComment.commentID);
        // if (shardsSnapshot != null && shardsSnapshot.data != null) {
        //   infoComment.likeCount = shardsSnapshot.data["count"];
        // }

        comments.add(infoComment);
      }

      return new FetchedCommentState(comments: comments);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

class ToggleLikeCommentEvent extends CommentEvent {
  ToggleLikeCommentEvent(
      {@required this.postID, @required this.commentID, this.isLike});
  @override
  String toString() => 'ToggleLikeCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  String postID;
  String commentID;
  bool isLike;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isLike == true) {
        await _commentProvider.addToLike(
            postID: postID, commentID: commentID, userID: userID);
        await _shardsProvider.increaseCommentLikeCount(commentID: commentID);
      } else {
        await _commentProvider.removeFromLike(
            postID: postID, commentID: commentID, userID: userID);
        await _shardsProvider.decreaseCommentLikeCount(commentID: commentID);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

class CreateCommentEvent extends CommentEvent {
  CreateCommentEvent({@required this.comment, @required this.byteDatas})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreateCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  FieldValue _firestoreTimestamp;
  List<ByteData> byteDatas;

  Comment comment;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      List<String> imageUrls = List<String>();
      if (byteDatas != null) {
        final String fileLocation = '$userID/posts';

        imageUrls = await _imageProvider.uploadCommentImages(
            fileLocation: fileLocation, byteDatas: byteDatas);
      }
      comment.userID = userID;
      comment.created = _firestoreTimestamp;
      comment.lastUpdate = _firestoreTimestamp;
      comment.imageUrls = imageUrls;
      DocumentReference reference =
          await _commentProvider.createComment(data: comment.data());
      if (reference == null) {
        return ErrorCommentState("error");
      }

      return new SuccessCommentState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

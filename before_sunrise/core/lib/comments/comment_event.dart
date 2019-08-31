import 'package:core/import.dart';

@immutable
abstract class CommentEvent {
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc});
}

class LoadCommentEvent extends CommentEvent {
  LoadCommentEvent(
      {@required this.category, @required this.postID, @required this.comment});
  @override
  String toString() => 'LoadCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  String category;
  String postID;
  Comment comment;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    print("LoadCommentEvent");
    try {
      QuerySnapshot snapshot = await _commentProvider.fetchComments(
          category: category, postID: postID, lastVisibleComment: comment);
      List<Comment> comments = List<Comment>();
      if (snapshot == null) {
        return EmptyCommentState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyCommentState();
      }

      String userID = await _authProvider.getUserID();
      for (var document in snapshot.documents) {
        Comment infoComment = Comment();
        infoComment.initialize(document);
        DocumentSnapshot snapshot =
            await _profileProvider.fetchProfile(userID: infoComment.userID);

        Profile profile = Profile();
        profile.initialize(snapshot);
        infoComment.profile = profile;
        if (userID == infoComment.userID) {
          infoComment.isMine = true;
        }

        if (infoComment.parentCommentID != null &&
            infoComment.parentCommentID.length > 0) {
          print(infoComment.parentCommentID);
          DocumentSnapshot documentSnapshot =
              await _commentProvider.fetchComment(
                  category: category,
                  postID: postID,
                  commentID: infoComment.parentCommentID);
          if (documentSnapshot != null) {
            Comment parentComment = Comment();
            parentComment.initialize(documentSnapshot);
            infoComment.parentText = parentComment.text;
            infoComment.parentImageUrls = parentComment.imageUrls;

            DocumentSnapshot parentSnapshot = await _profileProvider
                .fetchProfile(userID: parentComment.userID);
            if (parentSnapshot != null) {
              Profile parentProfile = Profile();
              parentProfile.initialize(parentSnapshot);
              infoComment.parentProfile = parentProfile;
            }
          }
        }

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

class CreateCommentEvent extends CommentEvent {
  CreateCommentEvent(
      {@required this.category,
      @required this.postID,
      @required this.comment,
      @required this.byteDatas})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreateCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  FieldValue _firestoreTimestamp;
  List<ByteData> byteDatas;

  String category;
  String postID;
  Comment comment;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      List<String> imageUrls = List<String>();
      if (byteDatas != null) {
        final String fileLocation = '$userID/comments';

        imageUrls = await _imageProvider.uploadPostImages(
            fileLocation: fileLocation, byteDatas: byteDatas);
      }
      comment.userID = userID;
      comment.created = _firestoreTimestamp;
      comment.lastUpdate = _firestoreTimestamp;
      comment.imageUrls = imageUrls;
      DocumentReference reference = await _commentProvider.createComment(
          category: category, postID: postID, data: comment.data());
      if (reference == null) {
        return ErrorCommentState("error");
      }

      _shardsProvider.increaseCommentCount(
        category: category,
        postID: postID,
      );
      return new SuccessCommentState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

class BindingCommentEvent extends CommentEvent {
  @override
  String toString() => 'BindingCommentEvent';

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      return new IdleCommentState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

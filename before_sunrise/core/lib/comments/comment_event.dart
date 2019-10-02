import 'package:core/import.dart';

@immutable
abstract class CommentEvent {
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc});

  final ICommentProvider _commentProvider = CommentProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  Future<Comment> loadProfile(String userID, Comment comment) async {
    DocumentSnapshot snapshot =
        await _profileProvider.fetchProfile(userID: comment.userID);

    Profile profile = Profile();
    profile.initialize(snapshot);
    comment.profile = profile;
    if (userID == comment.userID) {
      comment.isMine = true;
    }

    return comment;
  }

  Future<Comment> loadParentInfo(
      String category, String postID, Comment comment) async {
    if (comment == null ||
        comment.parentCommentID == null ||
        comment.parentCommentID.length <= 0) {
      return comment;
    }

    DocumentSnapshot documentSnapshot = await _commentProvider.fetchComment(
        category: category, postID: postID, commentID: comment.parentCommentID);
    if (documentSnapshot == null) {
      return comment;
    }

    Comment parentComment = Comment();
    parentComment.initialize(documentSnapshot);
    comment.parentText = parentComment.text;
    comment.parentImageUrls = parentComment.imageUrls;

    DocumentSnapshot parentSnapshot =
        await _profileProvider.fetchProfile(userID: parentComment.userID);
    if (parentSnapshot != null) {
      Profile parentProfile = Profile();
      parentProfile.initialize(parentSnapshot);
      comment.parentProfile = parentProfile;
    }

    return comment;
  }

  Comment cloneOtherDatabaseInfo(Comment sourceComment, Comment targetComment) {
    targetComment.profile = sourceComment.profile;
    targetComment.isLike = sourceComment.isLike;
    targetComment.likeCount = sourceComment.likeCount;
    targetComment.isReport = sourceComment.isReport;
    targetComment.reportCount = sourceComment.reportCount;
    targetComment.isMine = sourceComment.isMine;
    targetComment.profile = sourceComment.profile;
    targetComment.parentProfile = sourceComment.parentProfile;
    targetComment.parentText = sourceComment.parentText;
    targetComment.parentImageUrls = sourceComment.parentImageUrls;

    return targetComment;
  }
}

class LoadCommentEvent extends CommentEvent {
  LoadCommentEvent(
      {@required this.category, @required this.postID, @required this.comment});
  @override
  String toString() => 'LoadCommentEvent';
  final String category;
  final String postID;
  final Comment comment;

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
        infoComment = await loadProfile(userID, infoComment);
        infoComment = await loadParentInfo(category, postID, infoComment);

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
      @required this.editComment,
      @required this.byteDatas})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreateCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  FieldValue _firestoreTimestamp;
  final List<ByteData> byteDatas;

  final String category;
  final String postID;
  final Comment comment;
  final Comment editComment;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (comment.imageFolder == null || comment.imageFolder.isEmpty == true) {
        Uuid uuid = Uuid();
        String identifier = uuid.v4(options: {
          'positionalArgs': [userID]
        });
        print("identifier : ${identifier}");
        comment.imageFolder = identifier;
      }

      List<String> imageUrls = List<String>();
      if (byteDatas != null) {
        // 텍스트 -> 사진
        comment.text = "";
        if (editComment != null && editComment.imageUrls != null) {
          // 사진 -> 사진 o
          for (int i = 0; i < this.editComment.imageUrls.length; i++) {
            await _imageProvider.removeImage(
                imageUrl: this.editComment.imageUrls[i]);
          }
        }

        final String imageFolder = '$userID/comments/${comment.imageFolder}';

        imageUrls = await _imageProvider.uploadCommentImages(
            imageFolder: imageFolder, byteDatas: byteDatas);
      } else {
        // 사진 -> 텍스트
        comment.imageUrls = [];
        if (editComment != null && editComment.imageUrls != null) {
          for (int i = 0; i < this.editComment.imageUrls.length; i++) {
            await _imageProvider.removeImage(
                imageUrl: this.editComment.imageUrls[i]);
          }
        }
      }

      comment.userID = userID;
      comment.created = _firestoreTimestamp;
      comment.lastUpdate = _firestoreTimestamp;
      comment.imageUrls = imageUrls;

// Edit
      if (comment.commentID != null && comment.commentID.isEmpty == false) {
        comment.created = editComment.created;
        comment.lastUpdate = _firestoreTimestamp;

        DocumentSnapshot snapshot = await _commentProvider.updateComment(
            category: category, postID: postID, data: comment.data());

        Comment updateComment = Comment();
        updateComment.initialize(snapshot);
        updateComment = cloneOtherDatabaseInfo(comment, updateComment);

        return new SuccessCommentState(comment: updateComment);
      }

      DocumentReference reference = await _commentProvider.createComment(
          category: category, postID: postID, data: comment.data());
      if (reference == null) {
        return ErrorCommentState("error1");
      }

      DocumentSnapshot insertSnapshot = await reference.get();
      if (insertSnapshot == null) {
        return ErrorCommentState("error2");
      }

      Comment updatedComment = Comment();
      updatedComment.initialize(insertSnapshot);
      updatedComment = await loadProfile(userID, updatedComment);
      updatedComment = await loadParentInfo(category, postID, updatedComment);

      await _shardsProvider.increaseCommentCount(
        category: category,
        postID: postID,
      );

      return new SuccessCommentState(comment: updatedComment, isIncrease: true);
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

class EditCommentEvent extends CommentEvent {
  EditCommentEvent({
    @required this.comment,
  }) : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'EditCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final FieldValue _firestoreTimestamp;

  final Comment comment;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      return new EditCommentState(comment: comment);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

class ReplyCommentEvent extends CommentEvent {
  ReplyCommentEvent({
    @required this.parentComment,
  }) : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'ReplyCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final FieldValue _firestoreTimestamp;

  final Comment parentComment;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      return new ReplyCommentState(parentComment: parentComment);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

class RemoveCommentEvent extends CommentEvent {
  RemoveCommentEvent({
    @required this.comment,
    @required this.category,
    @required this.postID,
  }) : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'RemoveCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  final FieldValue _firestoreTimestamp;

  final Comment comment;
  final String category;
  final String postID;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      if (comment.imageUrls != null) {
        for (int i = 0; i < comment.imageUrls.length; i++) {
          await _imageProvider.removeImage(imageUrl: comment.imageUrls[i]);
        }
      }

      comment.text = "삭제된 댓글입니다.";
      comment.isRemove = true;
      comment.imageUrls = [];
      comment.lastUpdate = _firestoreTimestamp;

      DocumentSnapshot snapshot = await _commentProvider.updateComment(
          category: category, postID: postID, data: comment.data());

      Comment updateComment = Comment();
      updateComment.initialize(snapshot);
      updateComment = cloneOtherDatabaseInfo(comment, updateComment);

      return new SuccessCommentState(comment: updateComment);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

class MoveCommentEvent extends CommentEvent {
  MoveCommentEvent({
    @required this.commentID,
  }) : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'MoveCommentEvent';
  final ICommentProvider _commentProvider = CommentProvider();
  final FieldValue _firestoreTimestamp;

  final String commentID;

  @override
  Future<CommentState> applyAsync(
      {CommentState currentState, CommentBloc bloc}) async {
    try {
      return new MoveCommentState(commentID: commentID);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCommentState(_?.toString());
    }
  }
}

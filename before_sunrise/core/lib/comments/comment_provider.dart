import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class ICommentProvider {
  Future<bool> isLiked(
      {@required String postID,
      @required String commentID,
      @required String userID});

  Future<void> addToLike(
      {@required String postID,
      @required String commentID,
      @required String userID});

  Future<void> removeFromLike(
      {@required String postID,
      @required String commentID,
      @required String userID});

  Future<QuerySnapshot> fetchComment(
      {@required String postID, @required Comment lastVisibleComment});

  Future<QuerySnapshot> fetchCommentLikes(
      {@required String postID, @required String commentID});

  Future<DocumentReference> createComment(
      {@required Map<String, dynamic> data});
}

class CommentProvider implements ICommentProvider {
  CommentRepository _commentRepository;

  CommentProvider() {
    _commentRepository = CommentRepository();
  }

  Future<bool> isLiked(
      {@required String postID,
      @required String commentID,
      @required String userID}) async {
    return _commentRepository.isLiked(
        postID: postID, commentID: commentID, userID: userID);
  }

  Future<void> addToLike(
      {@required String postID,
      @required String commentID,
      @required String userID}) async {
    return _commentRepository.addToLike(
        postID: postID, commentID: commentID, userID: userID);
  }

  Future<void> removeFromLike(
      {@required String postID,
      @required String commentID,
      @required String userID}) async {
    return _commentRepository.removeFromLike(
        postID: postID, commentID: commentID, userID: userID);
  }

  Future<QuerySnapshot> fetchComment(
      {@required String postID, @required Comment lastVisibleComment}) async {
    return _commentRepository.fetchComment(
        postID: postID, lastVisibleComment: lastVisibleComment);
  }

  Future<QuerySnapshot> fetchCommentLikes(
      {@required String postID, @required String commentID}) async {
    return _commentRepository.fetchCommentLikes(
        postID: postID, commentID: commentID);
  }

  Future<DocumentReference> createComment(
      {@required Map<String, dynamic> data}) async {
    return _commentRepository.createComment(data: data);
  }
}

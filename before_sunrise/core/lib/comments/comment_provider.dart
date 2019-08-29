import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class ICommentProvider {
  Future<bool> isLiked(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID});
  Future<void> addToLike(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID});
  Future<void> removeFromLike(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID});
  Future<QuerySnapshot> fetchComment(
      {@required String category,
      @required String postID,
      @required Comment lastVisibleComment});
  Future<QuerySnapshot> fetchCommentLikes(
      {@required String category,
      @required String postID,
      @required String commentID});
  Future<QuerySnapshot> fetchComments(
      {@required String category,
      @required String postID,
      Comment lastVisibleComment});
  Future<DocumentReference> createComment(
      {@required String category,
      @required String postID,
      @required Map<String, dynamic> data});
}

class CommentProvider implements ICommentProvider {
  CommentRepository _commentRepository;

  CommentProvider() {
    _commentRepository = CommentRepository();
  }

  Future<bool> isLiked(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID}) async {
    return _commentRepository.isLiked(
        category: category,
        postID: postID,
        commentID: commentID,
        userID: userID);
  }

  Future<void> addToLike(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID}) async {
    return _commentRepository.addToLike(
        category: category,
        postID: postID,
        commentID: commentID,
        userID: userID);
  }

  Future<void> removeFromLike(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID}) async {
    return _commentRepository.removeFromLike(
        category: category,
        postID: postID,
        commentID: commentID,
        userID: userID);
  }

  Future<QuerySnapshot> fetchComment(
      {@required String category,
      @required String postID,
      @required Comment lastVisibleComment}) async {
    return _commentRepository.fetchComment(
        category: category,
        postID: postID,
        lastVisibleComment: lastVisibleComment);
  }

  Future<QuerySnapshot> fetchCommentLikes(
      {@required String category,
      @required String postID,
      @required String commentID}) async {
    return _commentRepository.fetchCommentLikes(
        category: category, postID: postID, commentID: commentID);
  }

  Future<QuerySnapshot> fetchComments(
      {@required String category,
      @required String postID,
      Comment lastVisibleComment}) async {
    return _commentRepository.fetchComments(
        category: category,
        postID: postID,
        lastVisibleComment: lastVisibleComment);
  }

  Future<DocumentReference> createComment(
      {@required String category,
      @required String postID,
      @required Map<String, dynamic> data}) async {
    return _commentRepository.createComment(
        category: category, postID: postID, data: data);
  }
}

import 'package:core/import.dart';

class CommentRepository {
  final CollectionReference _postCollection;

  CommentRepository()
      : _postCollection =
            Firestore.instance.collection(Config().root() + "/comment/posts");

  Future<bool> isLiked(
      {@required String postID,
      @required String commentID,
      @required String userID}) async {
    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('comments')
        .document(commentID)
        .collection('likes')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToLike(
      {@required String postID,
      @required String commentID,
      @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('comments')
        .document(commentID)
        .collection('likes')
        .document(userID)
        .setData({
      'isLiked': true,
    });
  }

  Future<void> removeFromLike(
      {@required String postID,
      @required String commentID,
      @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('comments')
        .document(commentID)
        .collection('likes')
        .document(userID)
        .delete();
  }

  Future<QuerySnapshot> fetchComment(
      {@required String postID, @required Comment lastVisibleComment}) {
    return lastVisibleComment == null
        ? _postCollection
            .document(postID)
            .collection('comments')
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadCommentCount)
            .getDocuments()
        : _postCollection
            .document(postID)
            .collection('comments')
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleComment.lastUpdate])
            .limit(CoreConst.maxLoadCommentCount)
            .getDocuments();
  }

  Future<QuerySnapshot> fetchCommentLikes(
      {@required String postID, @required String commentID}) {
    return _postCollection
        .document(postID)
        .collection('comments')
        .document(commentID)
        .collection('likes')
        .getDocuments();
  }

  Future<QuerySnapshot> fetchComments(
      {@required String postID, Comment lastVisibleComment}) {
    return lastVisibleComment == null
        ? _postCollection
            .document(postID)
            .collection('comments')
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _postCollection
            .document(postID)
            .collection('comments')
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleComment.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<DocumentReference> createComment(
      {@required String postID, @required Map<String, dynamic> data}) {
    return _postCollection.document(postID).collection('comments').add(data);
  }
}

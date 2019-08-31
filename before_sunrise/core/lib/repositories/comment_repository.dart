import 'package:core/import.dart';

class CommentRepository {
  CollectionReference _postCollection;
  Future<bool> isLiked(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID}) async {
    _postCollection = Firestore.instance
        .collection(Config().root() + "/${category}/${postID}/comments");

    final DocumentSnapshot snapshot = await _postCollection
        .document(commentID)
        .collection('likes')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToLike(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID}) {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    return _postCollection
        .document(commentID)
        .collection('likes')
        .document(userID)
        .setData({
      'isLiked': true,
    });
  }

  Future<void> removeFromLike(
      {@required String category,
      @required String postID,
      @required String commentID,
      @required String userID}) {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    return _postCollection
        .document(commentID)
        .collection('likes')
        .document(userID)
        .delete();
  }

  Future<DocumentSnapshot> fetchComment(
      {@required String category,
      @required String postID,
      @required String commentID}) {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    return _postCollection.document(commentID).get();
  }

  Future<QuerySnapshot> fetchCommentLikes(
      {@required String category,
      @required String postID,
      @required String commentID}) {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    return _postCollection
        .document(commentID)
        .collection('likes')
        .getDocuments();
  }

  Future<QuerySnapshot> fetchComments(
      {@required String category,
      @required String postID,
      Comment lastVisibleComment}) {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    return lastVisibleComment == null
        ? _postCollection
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadCommentCount)
            .getDocuments()
        : _postCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleComment.lastUpdate])
            .limit(CoreConst.maxLoadCommentCount)
            .getDocuments();
  }

  Future<DocumentReference> createComment(
      {@required String category,
      @required String postID,
      @required Map<String, dynamic> data}) {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    return _postCollection.add(data);
  }
}

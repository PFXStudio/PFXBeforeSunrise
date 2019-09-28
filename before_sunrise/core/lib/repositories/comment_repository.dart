import 'package:core/import.dart';

class CommentRepository {
  CollectionReference _postCollection;
  Future<bool> isLike(
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
      'isLike': true,
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
            .orderBy('created', descending: true)
            .limit(CoreConst.maxLoadCommentCount)
            .getDocuments()
        : _postCollection
            .orderBy('created', descending: true)
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

  Future<DocumentSnapshot> updateComment(
      {@required String category,
      @required String postID,
      @required Map<String, dynamic> data}) async {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    String commentID = data["commentID"];
    if (commentID != null && commentID.isEmpty == false) {
      await _postCollection.document(commentID).setData(data, merge: true);
      return await _postCollection.document(commentID).get();
    }

    return null;
  }

  Future<void> removeComments({
    @required String category,
    @required String postID,
  }) async {
    _postCollection = Firestore.instance
        .collection(Config().root() + "${category}/${postID}/comments");
    var comments = await _postCollection.getDocuments();
    if (comments.documents != null && comments.documents.length > 0) {
      for (var doc in comments.documents) {
        doc.reference.delete();
      }
    }
  }
}

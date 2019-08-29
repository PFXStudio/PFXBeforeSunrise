import 'package:core/import.dart';

class ShardsRepository {
  final CollectionReference _shardsCollection;
  final CollectionReference _postCollection;
  final CollectionReference _commentCollection;

  ShardsRepository()
      : _shardsCollection = Firestore.instance
            .collection(Config().root() + "/shards/likeCounters"),
        _postCollection =
            Firestore.instance.collection(Config().root() + "/free/posts"),
        _commentCollection =
            Firestore.instance.collection(Config().root() + "/comment/posts");

  Future<void> removePostCounter({@required String postID}) async {
    return await _shardsCollection.document(postID).delete();
  }

  Future<DocumentSnapshot> postLikedCount({@required String postID}) async {
    return await _shardsCollection.document(postID).get();
  }

  Future<void> increasePostLikeCount({@required String postID}) async {
    Stream<QuerySnapshot> querySnapshot =
        await _postCollection.document(postID).collection("likes").snapshots();
    if (querySnapshot == null) {
      return _shardsCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreasePostLikeCount({@required String postID}) async {
    Stream<QuerySnapshot> querySnapshot =
        await _postCollection.document(postID).collection("likes").snapshots();
    if (querySnapshot == null) {
      return _shardsCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> removeCommentCounter({@required String commentID}) async {
    return await _shardsCollection.document(commentID).delete();
  }

  Future<DocumentSnapshot> commentLikedCount(
      {@required String commentID}) async {
    return await _shardsCollection.document(commentID).get();
  }

  Future<void> increaseCommentLikeCount({@required String commentID}) async {
    Stream<QuerySnapshot> querySnapshot = await _commentCollection
        .document(commentID)
        .collection("likes")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsCollection
          .document(commentID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCollection
          .document(commentID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCollection
          .document(commentID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCollection
        .document(commentID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreaseCommentLikeCount({@required String commentID}) async {
    Stream<QuerySnapshot> querySnapshot = await _commentCollection
        .document(commentID)
        .collection("likes")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsCollection
          .document(commentID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCollection
          .document(commentID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCollection
          .document(commentID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCollection
        .document(commentID)
        .setData({"count": totalCount}, merge: true);
  }
}

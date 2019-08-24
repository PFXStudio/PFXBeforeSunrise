import 'package:core/import.dart';

class ShardsRepository {
  final CollectionReference _shardsCollection;
  final CollectionReference _postCollection;

  ShardsRepository()
      : _shardsCollection = Firestore.instance
            .collection(Config().root() + "/shards/likeCounters"),
        _postCollection =
            Firestore.instance.collection(Config().root() + "/free/posts");

  Future<void> removeCounter({@required String postID}) async {
    return await _shardsCollection.document(postID).delete();
  }

  Future<DocumentSnapshot> likedCount({@required String postID}) async {
    return await _shardsCollection.document(postID).get();
  }

  Future<void> increaseLikeCount({@required String postID}) async {
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

  Future<void> decreaseLikeCount({@required String postID}) async {
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
}

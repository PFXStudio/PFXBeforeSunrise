import 'package:core/import.dart';

class ShardsRepository {
  final CollectionReference _shardsLikeCollection;
  final CollectionReference _shardsCommentCollection;
  final CollectionReference _shardsReportCollection;
  final CollectionReference _shardsViewCollection;

  ShardsRepository()
      : _shardsLikeCollection = Firestore.instance
            .collection(Config().root() + "/shards/likeCounters"),
        _shardsCommentCollection = Firestore.instance
            .collection(Config().root() + "/shards/commentCounters"),
        _shardsReportCollection = Firestore.instance
            .collection(Config().root() + "/shards/reportCounters"),
        _shardsViewCollection = Firestore.instance
            .collection(Config().root() + "/shards/viewCounters");

  Future<void> removePostCounter({@required String postID}) async {
    return await _shardsLikeCollection.document(postID).delete();
  }

  Future<DocumentSnapshot> postLikedCount({@required String postID}) async {
    return await _shardsLikeCollection.document(postID).get();
  }

  Future<void> increasePostLikeCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);

    Stream<QuerySnapshot> querySnapshot =
        await _postCollection.document(postID).collection("likes").snapshots();
    if (querySnapshot == null) {
      return _shardsLikeCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsLikeCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsLikeCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsLikeCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreasePostLikeCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);
    Stream<QuerySnapshot> querySnapshot =
        await _postCollection.document(postID).collection("likes").snapshots();
    if (querySnapshot == null) {
      return _shardsLikeCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsLikeCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsLikeCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsLikeCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<DocumentSnapshot> commentCount({@required String postID}) async {
    return await _shardsCommentCollection.document(postID).get();
  }

  Future<void> increaseCommentCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);

    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("comments")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsCommentCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCommentCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCommentCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCommentCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreaseCommentCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);
    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("comments")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsCommentCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCommentCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCommentCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCommentCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<DocumentSnapshot> reporterCount({@required String postID}) async {
    return await _shardsReportCollection.document(postID).get();
  }

  Future<void> increaseReporterCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);

    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("reporters")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsReportCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsReportCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsReportCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsReportCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreaseReporterCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);
    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("reporters")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsReportCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsReportCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsReportCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsReportCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<DocumentSnapshot> viewerCount({@required String postID}) async {
    return await _shardsViewCollection.document(postID).get();
  }

  Future<void> increaseViewerCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);

    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("viewers")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsViewCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsViewCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsViewCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsViewCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreaseViewerCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);
    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("viewers")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsViewCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsViewCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsViewCollection
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsViewCollection
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }
}

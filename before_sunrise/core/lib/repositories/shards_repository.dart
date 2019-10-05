import 'package:core/import.dart';

class ShardsRepository {
  final CollectionReference _shardsPostLikeCounters;
  final CollectionReference _shardsCommentCounters;
  final CollectionReference _shardsReportCounters;
  final CollectionReference _shardsViewCounters;
  final CollectionReference _shardsClubInfoFavoriteCounters;

  ShardsRepository()
      : _shardsPostLikeCounters = Firestore.instance
            .collection(Config().root() + "/shards/postLikeCounters"),
        _shardsCommentCounters = Firestore.instance
            .collection(Config().root() + "/shards/commentCounters"),
        _shardsReportCounters = Firestore.instance
            .collection(Config().root() + "/shards/reportCounters"),
        _shardsViewCounters = Firestore.instance
            .collection(Config().root() + "/shards/viewCounters"),
        _shardsClubInfoFavoriteCounters = Firestore.instance
            .collection(Config().root() + "/shards/ClubInfoFavoriteCounters");

  Future<void> removePostLikeCount({@required String postID}) async {
    return await _shardsPostLikeCounters.document(postID).delete();
  }

  Future<DocumentSnapshot> postLikeCount({@required String postID}) async {
    return await _shardsPostLikeCounters.document(postID).get();
  }

  Future<void> increasePostLikeCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);

    Stream<QuerySnapshot> querySnapshot =
        await _postCollection.document(postID).collection("likes").snapshots();
    if (querySnapshot == null) {
      return _shardsPostLikeCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsPostLikeCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsPostLikeCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsPostLikeCounters
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
      return _shardsPostLikeCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsPostLikeCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsPostLikeCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsPostLikeCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> removeCommentCount({@required String postID}) async {
    return await _shardsCommentCounters.document(postID).delete();
  }

  Future<DocumentSnapshot> commentCount({@required String postID}) async {
    return await _shardsCommentCounters.document(postID).get();
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
      return _shardsCommentCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCommentCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCommentCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCommentCounters
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
      return _shardsCommentCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsCommentCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsCommentCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsCommentCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> removeReportCount({@required String postID}) async {
    return await _shardsReportCounters.document(postID).delete();
  }

  Future<DocumentSnapshot> reportCount({@required String postID}) async {
    return await _shardsReportCounters.document(postID).get();
  }

  Future<void> increaseReportCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);

    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("reports")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsReportCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsReportCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsReportCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsReportCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreaseReportCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);
    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("reports")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsReportCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsReportCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsReportCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsReportCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> removeViewCount({@required String postID}) async {
    return await _shardsViewCounters.document(postID).delete();
  }

  Future<DocumentSnapshot> viewCount({@required String postID}) async {
    return await _shardsViewCounters.document(postID).get();
  }

  Future<void> increaseViewCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);

    Stream<QuerySnapshot> querySnapshot =
        await _postCollection.document(postID).collection("views").snapshots();
    if (querySnapshot == null) {
      return _shardsViewCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsViewCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsViewCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsViewCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreaseViewCount(
      {@required String category, @required String postID}) async {
    CollectionReference _postCollection =
        Firestore.instance.collection(Config().root() + category);
    Stream<QuerySnapshot> querySnapshot =
        await _postCollection.document(postID).collection("views").snapshots();
    if (querySnapshot == null) {
      return _shardsViewCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsViewCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsViewCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsViewCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> removeClubInfoFavoriteCount({@required String postID}) async {
    return await _shardsClubInfoFavoriteCounters.document(postID).delete();
  }

  Future<DocumentSnapshot> clubInfoFavoriteCount(
      {@required String postID}) async {
    return await _shardsClubInfoFavoriteCounters.document(postID).get();
  }

  Future<void> increaseClubInfoFavoriteCount({@required String postID}) async {
    CollectionReference _postCollection = Firestore.instance
        .collection(Config().root() + CoreConst.clubInfoCategory);

    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("favorites")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsClubInfoFavoriteCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsClubInfoFavoriteCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsClubInfoFavoriteCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsClubInfoFavoriteCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }

  Future<void> decreaseClubInfoFavoriteCount({@required String postID}) async {
    CollectionReference _postCollection = Firestore.instance
        .collection(Config().root() + CoreConst.clubInfoCategory);
    Stream<QuerySnapshot> querySnapshot = await _postCollection
        .document(postID)
        .collection("favorites")
        .snapshots();
    if (querySnapshot == null) {
      return _shardsClubInfoFavoriteCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    QuerySnapshot snapshot = await querySnapshot.first;
    if (snapshot == null) {
      return _shardsClubInfoFavoriteCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }
    if (snapshot.documents == null) {
      return _shardsClubInfoFavoriteCounters
          .document(postID)
          .setData({"count": 0}, merge: true);
    }

    final totalCount = snapshot.documents.length;
    return _shardsClubInfoFavoriteCounters
        .document(postID)
        .setData({"count": totalCount}, merge: true);
  }
}

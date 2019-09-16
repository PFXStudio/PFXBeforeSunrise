import 'package:core/import.dart';

class TogetherRepository {
  final CollectionReference _postCollection;

  TogetherRepository()
      : _postCollection = Firestore.instance
            .collection(Config().root() + Together().category());

  Future<bool> isLike(
      {@required String postID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('likes')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToLike({@required String postID, @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('likes')
        .document(userID)
        .setData({
      'isLike': true,
    });
  }

  Future<void> removeFromLike(
      {@required String postID, @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('likes')
        .document(userID)
        .delete();
  }

  Future<bool> isReport(
      {@required String postID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('reports')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToReport({@required String postID, @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('reports')
        .document(userID)
        .setData({
      'isReported': true,
    }, merge: true);
  }

  Future<void> removeFromReport(
      {@required String postID, @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('reports')
        .document(userID)
        .delete();
  }

  Future<bool> isView(
      {@required String postID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('views')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToView({@required String postID, @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('views')
        .document(userID)
        .setData({
      'viewed': true,
    }, merge: true);
  }

  Future<DocumentSnapshot> fetchTogether({@required String postID}) {
    return _postCollection.document(postID).get();
  }

  Future<QuerySnapshot> fetchSubscribedLatestTogethers(
      {@required String userID}) {
    return _postCollection
        .orderBy('lastUpdate', descending: true)
        .where('userID', isEqualTo: userID)
        .limit(1)
        .getDocuments();
  }

  Future<QuerySnapshot> fetchTogetherLikes({@required String postID}) {
    return _postCollection.document(postID).collection('likes').getDocuments();
  }

  Future<QuerySnapshot> fetchTogethers(
      {@required String dateString, @required Together lastVisibleTogether}) {
    return lastVisibleTogether == null
        ? _postCollection
            .where('dateString', isEqualTo: dateString)
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _postCollection
            .where('dateString', isEqualTo: dateString)
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleTogether.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<QuerySnapshot> fetchProfileTogethers(
      {@required Together lastVisibleTogether, @required String userID}) {
    return lastVisibleTogether == null
        ? _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleTogether.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<DocumentReference> createTogether(
      {@required Map<String, dynamic> data}) {
    return _postCollection.add(data);
  }

  Future<void> removeTogether({@required String postID}) async {
    print("removeTogether $postID");
    QuerySnapshot likes = await _postCollection
        .document(postID)
        .collection("likes")
        .getDocuments();
    if (likes.documents != null && likes.documents.length > 0) {
      for (var doc in likes.documents) {
        doc.reference.delete();
      }
    }

    QuerySnapshot reports = await _postCollection
        .document(postID)
        .collection("reports")
        .getDocuments();
    if (reports.documents != null && reports.documents.length > 0) {
      for (var doc in reports.documents) {
        doc.reference.delete();
      }
    }

    QuerySnapshot views = await _postCollection
        .document(postID)
        .collection("views")
        .getDocuments();
    if (views.documents != null && views.documents.length > 0) {
      for (var doc in views.documents) {
        doc.reference.delete();
      }
    }

    return await _postCollection.document(postID).delete();
  }
}

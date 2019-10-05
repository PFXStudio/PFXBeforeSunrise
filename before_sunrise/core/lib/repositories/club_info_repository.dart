import 'package:core/import.dart';

class ClubInfoRepository {
  final CollectionReference _postCollection;

  ClubInfoRepository()
      : _postCollection = Firestore.instance
            .collection(Config().root() + CoreConst.clubInfoCategory);

  Future<bool> isFavorite(
      {@required String postID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('favorites')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToFavorite(
      {@required String postID, @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('favorites')
        .document(userID)
        .setData({
      'isLike': true,
    });
  }

  Future<void> removeFromFavorite(
      {@required String postID, @required String userID}) {
    return _postCollection
        .document(postID)
        .collection('favorites')
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

  Future<DocumentSnapshot> fetchClubInfo({@required String postID}) {
    return _postCollection.document(postID).get();
  }

  Future<QuerySnapshot> fetchSubscribedLatestClubInfos(
      {@required String userID}) {
    return _postCollection
        .orderBy('lastUpdate', descending: true)
        .where('userID', isEqualTo: userID)
        .limit(1)
        .getDocuments();
  }

  Future<QuerySnapshot> fetchClubInfoLikes({@required String postID}) {
    return _postCollection.document(postID).collection('likes').getDocuments();
  }

  Future<QuerySnapshot> fetchClubInfos(
      {@required ClubInfo lastVisibleClubInfo}) {
    return lastVisibleClubInfo == null
        ? _postCollection
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _postCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleClubInfo.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<QuerySnapshot> fetchProfileClubInfos(
      {@required ClubInfo lastVisibleClubInfo, @required String userID}) {
    return lastVisibleClubInfo == null
        ? _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleClubInfo.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<DocumentReference> createClubInfo(
      {@required Map<String, dynamic> data}) {
    return _postCollection.add(data);
  }

  Future<DocumentSnapshot> updateClubInfo(
      {@required Map<String, dynamic> data}) async {
    String postID = data["postID"];
    if (postID != null && postID.isEmpty == false) {
      await _postCollection.document(postID).setData(data, merge: true);
      return await _postCollection.document(postID).get();
    }

    return null;
  }

  Future<void> removeClubInfo({@required String postID}) async {
    print("removeClubInfo $postID");
    QuerySnapshot favorites = await _postCollection
        .document(postID)
        .collection("favorites")
        .getDocuments();
    if (favorites.documents != null && favorites.documents.length > 0) {
      for (var doc in favorites.documents) {
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

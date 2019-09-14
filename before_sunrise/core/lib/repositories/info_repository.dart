import 'package:core/import.dart';

class InfoRepository {
  final CollectionReference _infoCollection;

  InfoRepository()
      : _infoCollection =
            Firestore.instance.collection(Config().root() + "/info/clubs");

  Future<bool> isLike(
      {@required String infoID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _infoCollection
        .document(infoID)
        .collection('likes')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToLike({@required String infoID, @required String userID}) {
    return _infoCollection
        .document(infoID)
        .collection('likes')
        .document(userID)
        .setData({
      'isLike': true,
    });
  }

  Future<void> removeFromLike(
      {@required String infoID, @required String userID}) {
    return _infoCollection
        .document(infoID)
        .collection('likes')
        .document(userID)
        .delete();
  }

  Future<DocumentSnapshot> fetchInfo({@required String infoID}) {
    return _infoCollection.document(infoID).get();
  }

  Future<QuerySnapshot> fetchSubscribedLatestInfos({@required String userID}) {
    return _infoCollection
        .orderBy('lastUpdate', descending: true)
        .where('userID', isEqualTo: userID)
        .limit(1)
        .getDocuments();
  }

  Future<QuerySnapshot> fetchInfoLikes({@required String infoID}) {
    return _infoCollection.document(infoID).collection('likes').getDocuments();
  }

  Future<QuerySnapshot> fetchInfos({@required ClubInfo lastVisibleInfo}) {
    return lastVisibleInfo == null
        ? _infoCollection
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _infoCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleInfo.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<QuerySnapshot> fetchProfileInfos(
      {@required ClubInfo lastVisibleInfo, @required String userID}) {
    return lastVisibleInfo == null
        ? _infoCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _infoCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleInfo.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<DocumentReference> createInfo({@required Map<String, dynamic> data}) {
    return _infoCollection.add(data);
  }
}

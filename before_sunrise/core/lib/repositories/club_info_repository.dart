import 'package:core/import.dart';

class ClubInfoRepository {
  final CollectionReference _infoCollection;

  ClubInfoRepository()
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

  Future<DocumentSnapshot> fetchClubInfo({@required String infoID}) {
    return _infoCollection.document(infoID).get();
  }

  Future<QuerySnapshot> fetchSubscribedLatestClubInfos(
      {@required String userID}) {
    return _infoCollection
        .orderBy('lastUpdate', descending: true)
        .where('userID', isEqualTo: userID)
        .limit(1)
        .getDocuments();
  }

  Future<QuerySnapshot> fetchClubInfoLikes({@required String infoID}) {
    return _infoCollection.document(infoID).collection('likes').getDocuments();
  }

  Future<QuerySnapshot> fetchClubInfos(
      {@required ClubInfo lastVisibleClubInfo}) {
    return lastVisibleClubInfo == null
        ? _infoCollection
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _infoCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleClubInfo.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<QuerySnapshot> fetchProfileClubInfos(
      {@required ClubInfo lastVisibleClubInfo, @required String userID}) {
    return lastVisibleClubInfo == null
        ? _infoCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _infoCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisibleClubInfo.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<DocumentReference> createClubInfo(
      {@required Map<String, dynamic> data}) {
    return _infoCollection.add(data);
  }
}

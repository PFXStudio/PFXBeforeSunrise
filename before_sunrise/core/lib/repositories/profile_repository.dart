import 'package:core/import.dart';

class ProfileRepository {
  final CollectionReference _profileCollection;
  final FieldValue _firestoreTimestamp;

  ProfileRepository()
      : _profileCollection = Firestore.instance
            .collection(Config().root() + "/account/profiles"),
        _firestoreTimestamp = FieldValue.serverTimestamp();

  Future<DocumentSnapshot> hasProfile({@required String userID}) async {
    return _profileCollection.document(userID).get();
  }

  Future<QuerySnapshot> getProfileFollowers({@required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('followers')
        .getDocuments();
  }

  Future<QuerySnapshot> getProfileFollowing({@required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .getDocuments();
  }

  Future<DocumentSnapshot> fetchProfile({@required String userID}) {
    return _profileCollection.document(userID).get();
  }

  Future<bool> isLikeed(
      {@required String postID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(userID)
        .collection('likes')
        .document(postID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToLike({@required String postID, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('likes')
        .document(postID)
        .setData({
      'isLikeed': true,
      'lastUpdate': _firestoreTimestamp,
    });
  }

  Future<void> removeFromLike(
      {@required String postID, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('likes')
        .document(postID)
        .delete();
  }

  Future<bool> isFollowing(
      {@required String postUserID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToFollowing(
      {@required String postUserID, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserID)
        .setData({'isFollowing': true});
  }

  Future<void> removeFromFollowing(
      {@required String postUserID, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserID)
        .delete();
  }

  Future<bool> isFollower(
      {@required String postUserID, @required String userID}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(postUserID)
        .collection('followers')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToFollowers(
      {@required String postUserID, @required String userID}) {
    return _profileCollection
        .document(postUserID)
        .collection('followers')
        .document(userID)
        .setData({'isFollowing': true});
  }

  Future<void> removeFromFollowers(
      {@required String postUserID, @required String userID}) {
    return _profileCollection
        .document(postUserID)
        .collection('followers')
        .document(userID)
        .delete();
  }

  Future<QuerySnapshot> fetchLikedPosts({@required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('likes')
        .orderBy('lastUpdate', descending: true)
        .getDocuments();
  }

  Future<void> updateProfile({
    @required String userID,
    @required Object data,
  }) {
    return _profileCollection.document(userID).setData(data, merge: true);
  }

  Future<QuerySnapshot> selectProfile({
    @required String nickname,
  }) async {
    Query query =
        _profileCollection.where('nickname', isEqualTo: nickname).limit(1);
    final QuerySnapshot querySnapshot = await query.getDocuments();
    if (querySnapshot.documents.length <= 0) {
      return null;
    }

    return querySnapshot;
  }
}

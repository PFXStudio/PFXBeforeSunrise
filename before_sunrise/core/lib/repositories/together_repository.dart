import 'package:core/import.dart';

class TogetherRepository {
  final CollectionReference _postCollection;

  TogetherRepository()
      : _postCollection =
            Firestore.instance.collection(Config().root() + "/together/posts");

  Future<bool> isLiked(
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
      'isLiked': true,
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

  Future<QuerySnapshot> fetchTogethers({@required String dateString}) {
    return _postCollection
        // .orderBy('lastUpdate', descending: true)
        .where('dateTime', isEqualTo: dateString)
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
}

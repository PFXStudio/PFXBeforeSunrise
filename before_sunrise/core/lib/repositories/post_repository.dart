import 'package:core/import.dart';

class PostRepository {
  CollectionReference _postCollection;

  Future<bool> isLiked(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");

    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('likes')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToLike(
      {@required String category,
      @required String postID,
      @required String userID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection
        .document(postID)
        .collection('likes')
        .document(userID)
        .setData({
      'isLiked': true,
    });
  }

  Future<void> removeFromLike(
      {@required String category,
      @required String postID,
      @required String userID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection
        .document(postID)
        .collection('likes')
        .document(userID)
        .delete();
  }

  Future<DocumentSnapshot> fetchPost(
      {@required String category, @required String postID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection.document(postID).get();
  }

  Future<QuerySnapshot> fetchSubscribedLatestPosts(
      {@required String category, @required String userID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection
        .orderBy('lastUpdate', descending: true)
        .where('userID', isEqualTo: userID)
        .limit(1)
        .getDocuments();
  }

  Future<QuerySnapshot> fetchPostLikes(
      {@required String category, @required String postID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection.document(postID).collection('likes').getDocuments();
  }

  Future<QuerySnapshot> fetchPosts(
      {@required String category, @required Post lastVisiblePost}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return lastVisiblePost == null
        ? _postCollection
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _postCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisiblePost.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<QuerySnapshot> fetchProfilePosts(
      {@required String category,
      @required Post lastVisiblePost,
      @required String userID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return lastVisiblePost == null
        ? _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments()
        : _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisiblePost.lastUpdate])
            .limit(CoreConst.maxLoadPostCount)
            .getDocuments();
  }

  Future<DocumentReference> createPost(
      {@required String category, @required Map<String, dynamic> data}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection.add(data);
  }
}

import 'package:before_sunrise/import.dart';

class PostRepository {
  final CollectionReference _postCollection;

  PostRepository() : _postCollection = Firestore.instance.collection('posts');

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

  Future<DocumentSnapshot> fetchPost({@required String postID}) {
    return _postCollection.document(postID).get();
  }

  Future<QuerySnapshot> fetchSubscribedLatestPosts({@required String userID}) {
    return _postCollection
        .orderBy('lastUpdate', descending: true)
        .where('userID', isEqualTo: userID)
        .limit(1)
        .getDocuments();
  }

  Future<QuerySnapshot> fetchPostLikes({@required String postID}) {
    return _postCollection.document(postID).collection('likes').getDocuments();
  }

  Future<QuerySnapshot> fetchPosts({@required Post lastVisiblePost}) {
    return lastVisiblePost == null
        ? _postCollection
            .orderBy('lastUpdate', descending: true)
            .limit(5)
            .getDocuments()
        : _postCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisiblePost.lastUpdate])
            .limit(5)
            .getDocuments();
  }

  Future<QuerySnapshot> fetchProfilePosts(
      {@required Post lastVisiblePost, @required String userID}) {
    return lastVisiblePost == null
        ? _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .limit(5)
            .getDocuments()
        : _postCollection
            .where('userID', isEqualTo: userID)
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisiblePost.lastUpdate])
            .limit(5)
            .getDocuments();
  }

  Future<DocumentReference> createPost({@required Map<String, dynamic> data}) {
    return _postCollection.add(data);
  }
}

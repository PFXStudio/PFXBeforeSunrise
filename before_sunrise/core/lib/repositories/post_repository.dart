import 'package:core/import.dart';

class PostRepository {
  CollectionReference _postCollection;

  Future<bool> isLike(
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
      'isLike': true,
    }, merge: true);
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

  Future<bool> isReport(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");

    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('reports')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToReport(
      {@required String category,
      @required String postID,
      @required String userID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection
        .document(postID)
        .collection('reports')
        .document(userID)
        .setData({
      'isReported': true,
    }, merge: true);
  }

  Future<void> removeFromReport(
      {@required String category,
      @required String postID,
      @required String userID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection
        .document(postID)
        .collection('reports')
        .document(userID)
        .delete();
  }

  Future<bool> isView(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");

    final DocumentSnapshot snapshot = await _postCollection
        .document(postID)
        .collection('views')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToView(
      {@required String category,
      @required String postID,
      @required String userID}) {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    return _postCollection
        .document(postID)
        .collection('views')
        .document(userID)
        .setData({
      'viewed': true,
    }, merge: true);
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

  Future<void> removePost(
      {@required String category, @required String postID}) async {
    _postCollection =
        Firestore.instance.collection(Config().root() + "${category}");
    await _postCollection
        .document(postID)
        .collection("likes")
        .getDocuments()
        .then((snapshot) {
      return snapshot.documents.map((doc) {
        doc.reference.delete();
      });
    });

    await _postCollection
        .document(postID)
        .collection("reports")
        .getDocuments()
        .then((snapshot) {
      return snapshot.documents.map((doc) {
        doc.reference.delete();
      });
    });

    await _postCollection
        .document(postID)
        .collection("views")
        .getDocuments()
        .then((snapshot) {
      return snapshot.documents.map((doc) {
        doc.reference.delete();
      });
    });

    return await _postCollection.document(postID).delete();
  }
}

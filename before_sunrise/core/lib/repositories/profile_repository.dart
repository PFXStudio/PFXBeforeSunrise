import 'package:core/import.dart';

class ProfileRepository {
  // final Firestore _firestore;
  final CollectionReference _profileCollection;
  final FieldValue _firestoreTimestamp;

  ProfileRepository()
      : _profileCollection = Firestore.instance.collection('profiles'),
        _firestoreTimestamp = FieldValue.serverTimestamp();

  Future<DocumentSnapshot> hasProfile({@required String userID}) async {
    return _profileCollection.document(userID).get();
  }

  Future<bool> isLiked(
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
      'isLiked': true,
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

  Future<bool> isSubscribedTo(
      {@required String postUserId, @required String userID}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserId)
        .get();

    return snapshot.exists;
  }

  Future<void> subscribeTo(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserId)
        .setData({'isFollowing': true});
  }

  Future<void> unsubscribeFrom(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserId)
        .delete();
  }

  Future<bool> isSubscriber(
      {@required String postUserId, @required String userID}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToSubscribers(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userID)
        .setData({'isFollowing': true});
  }

  Future<void> removeFromSubscribers(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userID)
        .delete();
  }

  Future<QuerySnapshot> fetchProfileLikedPosts({@required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('likes')
        .orderBy('lastUpdate', descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> fetchProfileSubscribers({@required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('followers')
        .getDocuments();
  }

  Future<QuerySnapshot> fetchProfileSubscriptions({@required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .getDocuments();
  }

  Future<DocumentSnapshot> fetchProfile({@required String userID}) {
    return _profileCollection.document(userID).get();
  }

  Future<void> createProfile(
      {@required String userID,
      @required String firstName,
      @required String lastName,
      @required String businessName,
      @required String businessDescription,
      @required String phoneNumber,
      String otherPhoneNumber,
      @required String businessLocation,
      @required String profileImageUrl}) {
    return _profileCollection.document(userID).setData({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'businessName': businessName,
      'businessDescription': businessDescription,
      'phoneNumber': phoneNumber,
      'otherPhoneNumber': otherPhoneNumber,
      'businessLocation': businessLocation,
      'profileImageUrl': profileImageUrl,
      'hasProfile': true,
      'created': _firestoreTimestamp,
      'lastUpdate': _firestoreTimestamp,
    }, merge: true);
  }
}

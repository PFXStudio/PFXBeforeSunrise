import 'package:core/import.dart';
import 'package:core/networks/i_client.dart';

typedef CreateVerifyCodeCallback = void Function(String code);

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _profileCollection;
  final FieldValue _firestoreTimestamp;

  AuthRepository()
      : _profileCollection = Firestore.instance
            .collection(Config().root() + "/account/profiles"),
        _firestoreTimestamp = FieldValue.serverTimestamp();

  Future<bool> isSingedIn() async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    return currentUser != null ? true : false;
  }

  Future<String> getUserID() async {
    return (await _firebaseAuth.currentUser()).uid ?? '';
  }

  Future<String> getPhoneNumber() async {
    return (await _firebaseAuth.currentUser()).phoneNumber ?? '';
  }

  Future<bool> requestVerifyCode(
      {@required String phoneNumber,
      @required String countryIsoCode,
      @required CreateVerifyCodeCallback callback}) async {
    try {
      if (!await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: phoneNumber, isoCode: countryIsoCode)) {
        throw Exception('Invalid phone number!');
      }

      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        _firebaseAuth.signInWithCredential(phoneAuthCredential);

        print('Received phone auth credential: $phoneAuthCredential');
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
        callback(null);
      };

      final PhoneCodeSent codeSent =
          (String verificationID, [int forceResendingToken]) async {
        print('Please check your phone for the verification code.');

        print('PhoneCodeSent $verificationID');
        callback(verificationID);
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        callback(null);
      };

      print(phoneNumber);

      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 0),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

      return true;
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<String> requestAuth(
      {@required String verificationCode,
      @required String verificationID}) async {
    try {
      if (verificationID == null || verificationID.length <= 0) {
        throw Exception('Invalid verificationID!');
      }

      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationID,
        smsCode: verificationCode,
      );

      final FirebaseUser user =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);

      return user != null ? user.uid : "";
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<void> requestSignout() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  /////////////////////////////////// Profiles
  Future<DocumentSnapshot> hasProfile(String userID) async {
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
      {@required String postUserId, @required String userID}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserId)
        .get();

    return snapshot.exists;
  }

  Future<void> addToFollowing(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserId)
        .setData({'isFollowing': true});
  }

  Future<void> removeFromFollowing(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(userID)
        .collection('following')
        .document(postUserId)
        .delete();
  }

  Future<bool> isFollower(
      {@required String postUserId, @required String userID}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userID)
        .get();

    return snapshot.exists;
  }

  Future<void> addToFollowers(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userID)
        .setData({'isFollowing': true});
  }

  Future<void> removeFromFollowers(
      {@required String postUserId, @required String userID}) {
    return _profileCollection
        .document(postUserId)
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

  /////////////////////////////////// Profiles

}

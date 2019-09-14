import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IProfileProvider {
  Future<DocumentSnapshot> hasProfile({@required String userID});
  Future<QuerySnapshot> getProfileFollowers({@required String userID});
  Future<QuerySnapshot> getProfileFollowing({@required String userID});
  Future<DocumentSnapshot> fetchProfile({@required String userID});
  Future<bool> isLike({@required String postID, @required String userID});
  Future<void> addToLike({@required String postID, @required String userID});
  Future<void> removeFromLike(
      {@required String postID, @required String userID});
  Future<bool> isFollowing(
      {@required String postUserID, @required String userID});
  Future<void> addToFollowing(
      {@required String postUserID, @required String userID});
  Future<void> removeFromFollowing(
      {@required String postUserID, @required String userID});
  Future<bool> isFollower(
      {@required String postUserID, @required String userID});
  Future<void> addToFollowers(
      {@required String postUserID, @required String userID});
  Future<void> removeFromFollowers(
      {@required String postUserID, @required String userID});
  Future<QuerySnapshot> fetchLikedPosts({@required String userID});
  Future<void> updateProfile({
    @required String userID,
    @required Object data,
  });
  Future<QuerySnapshot> selectProfile({
    @required String nickname,
  });
  Future<void> removeProfile({
    @required String userID,
  });
}

class ProfileProvider implements IProfileProvider {
  ProfileRepository _profileRepository;

  ProfileProvider() {
    _profileRepository = ProfileRepository();
  }

  @override
  Future<void> addToFollowers({String postUserID, String userID}) {
    return _profileRepository.addToFollowers(
        postUserID: postUserID, userID: userID);
  }

  @override
  Future<void> addToFollowing({String postUserID, String userID}) {
    return _profileRepository.addToFollowing(
        postUserID: postUserID, userID: userID);
  }

  @override
  Future<void> addToLike({String postID, String userID}) {
    return _profileRepository.addToLike(postID: postID, userID: userID);
  }

  @override
  Future<QuerySnapshot> fetchLikedPosts({String userID}) {
    return _profileRepository.fetchLikedPosts(userID: userID);
  }

  @override
  Future<DocumentSnapshot> fetchProfile({String userID}) {
    return _profileRepository.fetchProfile(userID: userID);
  }

  @override
  Future<QuerySnapshot> getProfileFollowers({String userID}) {
    return _profileRepository.getProfileFollowers(userID: userID);
  }

  @override
  Future<QuerySnapshot> getProfileFollowing({String userID}) {
    return _profileRepository.getProfileFollowing(userID: userID);
  }

  @override
  Future<DocumentSnapshot> hasProfile({String userID}) {
    return _profileRepository.hasProfile(userID: userID);
  }

  @override
  Future<bool> isFollower({String postUserID, String userID}) {
    return _profileRepository.isFollower(
        postUserID: postUserID, userID: userID);
  }

  @override
  Future<bool> isFollowing({String postUserID, String userID}) {
    return _profileRepository.isFollowing(
        postUserID: postUserID, userID: userID);
  }

  @override
  Future<bool> isLike({String postID, String userID}) {
    return _profileRepository.isLike(postID: postID, userID: userID);
  }

  @override
  Future<void> removeFromFollowers({String postUserID, String userID}) {
    return _profileRepository.removeFromFollowers(
        postUserID: postUserID, userID: userID);
  }

  @override
  Future<void> removeFromFollowing({String postUserID, String userID}) {
    return _profileRepository.removeFromFollowing(
        postUserID: postUserID, userID: userID);
  }

  @override
  Future<void> removeFromLike({String postID, String userID}) {
    return _profileRepository.removeFromLike(postID: postID, userID: userID);
  }

  @override
  Future<QuerySnapshot> selectProfile({String nickname}) {
    return _profileRepository.selectProfile(nickname: nickname);
  }

  @override
  Future<void> updateProfile({String userID, Object data}) {
    return _profileRepository.updateProfile(userID: userID, data: data);
  }

  @override
  Future<void> removeProfile({String userID}) {
    return _profileRepository.removeProfile(userID: userID);
  }
}

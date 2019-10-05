import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IClubInfoProvider {
  Future<bool> isFavorite({@required String postID, @required String userID});
  Future<void> addToFavorite(
      {@required String postID, @required String userID});
  Future<void> removeFromFavorite(
      {@required String postID, @required String userID});
  Future<bool> isReport({@required String postID, @required String userID});
  Future<void> addToReport({@required String postID, @required String userID});
  Future<void> removeFromReport(
      {@required String postID, @required String userID});
  Future<bool> isView({@required String postID, @required String userID});
  Future<void> addToView({@required String postID, @required String userID});

  Future<DocumentSnapshot> fetchClubInfo({@required String postID});
  Future<QuerySnapshot> fetchSubscribedLatestClubInfos(
      {@required String userID});
  Future<QuerySnapshot> fetchClubInfoLikes({@required String postID});
  Future<QuerySnapshot> fetchClubInfos(
      {@required ClubInfo lastVisibleClubInfo});
  Future<QuerySnapshot> fetchProfileClubInfos(
      {@required ClubInfo lastVisibleClubInfo, @required String userID});
  Future<DocumentReference> createClubInfo(
      {@required Map<String, dynamic> data});
  Future<DocumentSnapshot> updateClubInfo(
      {@required Map<String, dynamic> data});
  Future<void> removeClubInfo({@required String postID});
}

class ClubInfoProvider implements IClubInfoProvider {
  ClubInfoRepository _postRepository;

  ClubInfoProvider() {
    _postRepository = ClubInfoRepository();
  }

  Future<bool> isFavorite(
      {@required String postID, @required String userID}) async {
    return await _postRepository.isFavorite(postID: postID, userID: userID);
  }

  Future<void> addToFavorite(
      {@required String postID, @required String userID}) async {
    return await _postRepository.addToFavorite(postID: postID, userID: userID);
  }

  Future<void> removeFromFavorite(
      {@required String postID, @required String userID}) async {
    return await _postRepository.removeFromFavorite(
        postID: postID, userID: userID);
  }

  Future<bool> isReport(
      {@required String postID, @required String userID}) async {
    return await _postRepository.isReport(postID: postID, userID: userID);
  }

  Future<void> addToReport(
      {@required String postID, @required String userID}) async {
    return await _postRepository.addToReport(postID: postID, userID: userID);
  }

  Future<void> removeFromReport(
      {@required String postID, @required String userID}) async {
    return await _postRepository.removeFromReport(
        postID: postID, userID: userID);
  }

  Future<bool> isView(
      {@required String postID, @required String userID}) async {
    return await _postRepository.isView(postID: postID, userID: userID);
  }

  Future<void> addToView(
      {@required String postID, @required String userID}) async {
    return await _postRepository.addToView(postID: postID, userID: userID);
  }

  Future<DocumentSnapshot> fetchClubInfo({@required String postID}) async {
    return await _postRepository.fetchClubInfo(postID: postID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestClubInfos(
      {@required String userID}) async {
    return await _postRepository.fetchSubscribedLatestClubInfos(userID: userID);
  }

  Future<QuerySnapshot> fetchClubInfoLikes({@required String postID}) async {
    return await _postRepository.fetchClubInfoLikes(postID: postID);
  }

  Future<QuerySnapshot> fetchClubInfos(
      {@required ClubInfo lastVisibleClubInfo}) async {
    return await _postRepository.fetchClubInfos(
        lastVisibleClubInfo: lastVisibleClubInfo);
  }

  Future<QuerySnapshot> fetchProfileClubInfos(
      {@required ClubInfo lastVisibleClubInfo, @required String userID}) async {
    return await _postRepository.fetchProfileClubInfos(
        lastVisibleClubInfo: lastVisibleClubInfo, userID: userID);
  }

  Future<DocumentReference> createClubInfo(
      {@required Map<String, dynamic> data}) async {
    return await _postRepository.createClubInfo(data: data);
  }

  Future<DocumentSnapshot> updateClubInfo(
      {@required Map<String, dynamic> data}) async {
    return await _postRepository.updateClubInfo(data: data);
  }

  Future<void> removeClubInfo({@required String postID}) async {
    return await _postRepository.removeClubInfo(postID: postID);
  }
}

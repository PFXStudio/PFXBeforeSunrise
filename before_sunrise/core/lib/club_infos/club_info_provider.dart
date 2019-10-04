import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IClubInfoProvider {
  Future<bool> isLike({@required String infoID, @required String userID});
  Future<void> addToLike({@required String infoID, @required String userID});
  Future<void> removeFromLike(
      {@required String infoID, @required String userID});
  Future<DocumentSnapshot> fetchClubInfo({@required String infoID});
  Future<QuerySnapshot> fetchSubscribedLatestClubInfos(
      {@required String userID});
  Future<QuerySnapshot> fetchClubInfoLikes({@required String infoID});
  Future<QuerySnapshot> fetchClubInfos(
      {@required ClubInfo lastVisibleClubInfo});
  Future<QuerySnapshot> fetchProfileClubInfos(
      {@required ClubInfo lastVisibleClubInfo, @required String userID});
  Future<DocumentReference> createClubInfo(
      {@required Map<String, dynamic> data});
}

class ClubInfoProvider implements IClubInfoProvider {
  ClubInfoRepository _infoRepository;

  ClubInfoProvider() {
    _infoRepository = ClubInfoRepository();
  }

  Future<bool> isLike(
      {@required String infoID, @required String userID}) async {
    return await _infoRepository.isLike(infoID: infoID, userID: userID);
  }

  Future<void> addToLike(
      {@required String infoID, @required String userID}) async {
    return await _infoRepository.addToLike(infoID: infoID, userID: userID);
  }

  Future<void> removeFromLike(
      {@required String infoID, @required String userID}) async {
    return await _infoRepository.removeFromLike(infoID: infoID, userID: userID);
  }

  Future<DocumentSnapshot> fetchClubInfo({@required String infoID}) async {
    return await _infoRepository.fetchClubInfo(infoID: infoID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestClubInfos(
      {@required String userID}) async {
    return await _infoRepository.fetchSubscribedLatestClubInfos(userID: userID);
  }

  Future<QuerySnapshot> fetchClubInfoLikes({@required String infoID}) async {
    return await _infoRepository.fetchClubInfoLikes(infoID: infoID);
  }

  Future<QuerySnapshot> fetchClubInfos(
      {@required ClubInfo lastVisibleClubInfo}) async {
    return await _infoRepository.fetchClubInfos(
        lastVisibleClubInfo: lastVisibleClubInfo);
  }

  Future<QuerySnapshot> fetchProfileClubInfos(
      {@required ClubInfo lastVisibleClubInfo, @required String userID}) async {
    return await _infoRepository.fetchProfileClubInfos(
        lastVisibleClubInfo: lastVisibleClubInfo, userID: userID);
  }

  Future<DocumentReference> createClubInfo(
      {@required Map<String, dynamic> data}) async {
    return await _infoRepository.createClubInfo(data: data);
  }
}

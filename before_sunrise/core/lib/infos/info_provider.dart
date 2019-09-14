import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IInfoProvider {
  Future<bool> isLike({@required String infoID, @required String userID});
  Future<void> addToLike({@required String infoID, @required String userID});
  Future<void> removeFromLike(
      {@required String infoID, @required String userID});
  Future<DocumentSnapshot> fetchInfo({@required String infoID});
  Future<QuerySnapshot> fetchSubscribedLatestInfos({@required String userID});
  Future<QuerySnapshot> fetchInfoLikes({@required String infoID});
  Future<QuerySnapshot> fetchInfos({@required ClubInfo lastVisibleInfo});
  Future<QuerySnapshot> fetchProfileInfos(
      {@required ClubInfo lastVisibleInfo, @required String userID});
  Future<DocumentReference> createInfo({@required Map<String, dynamic> data});
}

class InfoProvider implements IInfoProvider {
  InfoRepository _infoRepository;

  InfoProvider() {
    _infoRepository = InfoRepository();
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

  Future<DocumentSnapshot> fetchInfo({@required String infoID}) async {
    return await _infoRepository.fetchInfo(infoID: infoID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestInfos(
      {@required String userID}) async {
    return await _infoRepository.fetchSubscribedLatestInfos(userID: userID);
  }

  Future<QuerySnapshot> fetchInfoLikes({@required String infoID}) async {
    return await _infoRepository.fetchInfoLikes(infoID: infoID);
  }

  Future<QuerySnapshot> fetchInfos({@required ClubInfo lastVisibleInfo}) async {
    return await _infoRepository.fetchInfos(lastVisibleInfo: lastVisibleInfo);
  }

  Future<QuerySnapshot> fetchProfileInfos(
      {@required ClubInfo lastVisibleInfo, @required String userID}) async {
    return await _infoRepository.fetchProfileInfos(
        lastVisibleInfo: lastVisibleInfo, userID: userID);
  }

  Future<DocumentReference> createInfo(
      {@required Map<String, dynamic> data}) async {
    return await _infoRepository.createInfo(data: data);
  }
}

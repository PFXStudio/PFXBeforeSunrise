import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class ITogetherProvider {
  Future<bool> isLike({@required String postID, @required String userID});
  Future<void> addToLike({@required String postID, @required String userID});
  Future<void> removeFromLike(
      {@required String postID, @required String userID});
  Future<bool> isReport({@required String postID, @required String userID});
  Future<void> addToReport({@required String postID, @required String userID});
  Future<void> removeFromReport(
      {@required String postID, @required String userID});
  Future<bool> isView({@required String postID, @required String userID});
  Future<void> addToView({@required String postID, @required String userID});

  Future<DocumentSnapshot> fetchTogether({@required String postID});
  Future<QuerySnapshot> fetchSubscribedLatestTogethers(
      {@required String userID});
  Future<QuerySnapshot> fetchTogetherLikes({@required String postID});
  Future<QuerySnapshot> fetchTogethers(
      {@required String dateString, @required Together lastVisibleTogether});
  Future<QuerySnapshot> fetchProfileTogethers(
      {@required Together lastVisibleTogether, @required String userID});
  Future<DocumentReference> createTogether(
      {@required Map<String, dynamic> data});
  Future<void> removeTogether({@required String postID});
}

class TogetherProvider implements ITogetherProvider {
  TogetherRepository _togetherRepository;

  TogetherProvider() {
    _togetherRepository = TogetherRepository();
  }

  Future<bool> isLike(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.isLike(postID: postID, userID: userID);
  }

  Future<void> addToLike(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.addToLike(postID: postID, userID: userID);
  }

  Future<void> removeFromLike(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.removeFromLike(
        postID: postID, userID: userID);
  }

  Future<bool> isReport(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.isReport(postID: postID, userID: userID);
  }

  Future<void> addToReport(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.addToReport(
        postID: postID, userID: userID);
  }

  Future<void> removeFromReport(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.removeFromReport(
        postID: postID, userID: userID);
  }

  Future<bool> isView(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.isView(postID: postID, userID: userID);
  }

  Future<void> addToView(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.addToView(postID: postID, userID: userID);
  }

  Future<DocumentSnapshot> fetchTogether({@required String postID}) async {
    return await _togetherRepository.fetchTogether(postID: postID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestTogethers(
      {@required String userID}) async {
    return await _togetherRepository.fetchSubscribedLatestTogethers(
        userID: userID);
  }

  Future<QuerySnapshot> fetchTogetherLikes({@required String postID}) async {
    return await _togetherRepository.fetchTogetherLikes(postID: postID);
  }

  Future<QuerySnapshot> fetchTogethers(
      {@required String dateString,
      @required Together lastVisibleTogether}) async {
    return await _togetherRepository.fetchTogethers(
        dateString: dateString, lastVisibleTogether: lastVisibleTogether);
  }

  Future<QuerySnapshot> fetchProfileTogethers(
      {@required Together lastVisibleTogether, @required String userID}) async {
    return await _togetherRepository.fetchProfileTogethers(
        lastVisibleTogether: lastVisibleTogether, userID: userID);
  }

  Future<DocumentReference> createTogether(
      {@required Map<String, dynamic> data}) async {
    return await _togetherRepository.createTogether(data: data);
  }

  Future<void> removeTogether({@required String postID}) async {
    return await _togetherRepository.removeTogether(postID: postID);
  }
}

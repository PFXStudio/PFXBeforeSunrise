import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class ITogetherProvider {
  Future<bool> isLiked({@required String postID, @required String userID});
  Future<void> addToLike({@required String postID, @required String userID});
  Future<void> removeFromLike(
      {@required String postID, @required String userID});
  Future<DocumentSnapshot> fetchTogether({@required String postID});
  Future<QuerySnapshot> fetchSubscribedLatestTogethers(
      {@required String userID});
  Future<QuerySnapshot> fetchTogetherLikes({@required String postID});
  Future<QuerySnapshot> fetchTogethers({@required String dateString});
  Future<QuerySnapshot> fetchProfileTogethers(
      {@required Together lastVisibleTogether, @required String userID});
  Future<DocumentReference> createTogether(
      {@required Map<String, dynamic> data});
}

class TogetherProvider implements ITogetherProvider {
  TogetherRepository _togetherRepository;

  TogetherProvider() {
    _togetherRepository = TogetherRepository();
  }

  Future<bool> isLiked(
      {@required String postID, @required String userID}) async {
    return await _togetherRepository.isLiked(postID: postID, userID: userID);
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

  Future<QuerySnapshot> fetchTogethers({@required String dateString}) async {
    return await _togetherRepository.fetchTogethers(dateString: dateString);
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
}

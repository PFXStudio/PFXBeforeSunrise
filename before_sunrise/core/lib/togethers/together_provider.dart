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
  Future<QuerySnapshot> fetchTogethers({@required Post lastVisibleTogether});
  Future<QuerySnapshot> fetchProfileTogethers(
      {@required Post lastVisibleTogether, @required String userID});
  Future<DocumentReference> createTogether(
      {@required Map<String, dynamic> data});
}

class TogetherProvider implements ITogetherProvider {
  PostRepository _postRepository;

  TogetherProvider() {
    _postRepository = PostRepository();
  }

  Future<bool> isLiked(
      {@required String postID, @required String userID}) async {
    return await _postRepository.isLiked(postID: postID, userID: userID);
  }

  Future<void> addToLike(
      {@required String postID, @required String userID}) async {
    return await _postRepository.addToLike(postID: postID, userID: userID);
  }

  Future<void> removeFromLike(
      {@required String postID, @required String userID}) async {
    return await _postRepository.removeFromLike(postID: postID, userID: userID);
  }

  Future<DocumentSnapshot> fetchTogether({@required String postID}) async {
    return await _postRepository.fetchPost(postID: postID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestTogethers(
      {@required String userID}) async {
    return await _postRepository.fetchSubscribedLatestPosts(userID: userID);
  }

  Future<QuerySnapshot> fetchTogetherLikes({@required String postID}) async {
    return await _postRepository.fetchPostLikes(postID: postID);
  }

  Future<QuerySnapshot> fetchTogethers(
      {@required Post lastVisibleTogether}) async {
    return await _postRepository.fetchPosts(
        lastVisiblePost: lastVisibleTogether);
  }

  Future<QuerySnapshot> fetchProfileTogethers(
      {@required Post lastVisibleTogether, @required String userID}) async {
    return await _postRepository.fetchProfilePosts(
        lastVisiblePost: lastVisibleTogether, userID: userID);
  }

  Future<DocumentReference> createTogether(
      {@required Map<String, dynamic> data}) async {
    return await _postRepository.createPost(data: data);
  }
}

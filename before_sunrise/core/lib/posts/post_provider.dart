import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IPostProvider {
  Future<bool> isLiked({@required String postID, @required String userID});
  Future<void> addToLike({@required String postID, @required String userID});
  Future<void> removeFromLike(
      {@required String postID, @required String userID});
  Future<DocumentSnapshot> fetchPost({@required String postID});
  Future<QuerySnapshot> fetchSubscribedLatestPosts({@required String userID});
  Future<QuerySnapshot> fetchPostLikes({@required String postID});
  Future<QuerySnapshot> fetchPosts({@required Post lastVisiblePost});
  Future<QuerySnapshot> fetchProfilePosts(
      {@required Post lastVisiblePost, @required String userID});
  Future<DocumentReference> createPost({@required Map<String, dynamic> data});
}

class PostProvider implements IPostProvider {
  PostRepository _postRepository;

  PostProvider() {
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

  Future<DocumentSnapshot> fetchPost({@required String postID}) async {
    return await _postRepository.fetchPost(postID: postID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestPosts(
      {@required String userID}) async {
    return await _postRepository.fetchSubscribedLatestPosts(userID: userID);
  }

  Future<QuerySnapshot> fetchPostLikes({@required String postID}) async {
    return await _postRepository.fetchPostLikes(postID: postID);
  }

  Future<QuerySnapshot> fetchPosts({@required Post lastVisiblePost}) async {
    return await _postRepository.fetchPosts(lastVisiblePost: lastVisiblePost);
  }

  Future<QuerySnapshot> fetchProfilePosts(
      {@required Post lastVisiblePost, @required String userID}) async {
    return await _postRepository.fetchProfilePosts(
        lastVisiblePost: lastVisiblePost, userID: userID);
  }

  Future<DocumentReference> createPost(
      {@required Map<String, dynamic> data}) async {
    return await _postRepository.createPost(data: data);
  }
}

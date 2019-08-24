import 'package:core/import.dart';
import 'package:core/my_posts/my_post_state.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IMyPostProvider {
  Future<bool> isLiked({@required String postID, @required String userID});
  Future<void> addToLike({@required String postID, @required String userID});
  Future<void> removeFromLike(
      {@required String postID, @required String userID});
  Future<DocumentSnapshot> fetchMyPost({@required String postID});
  Future<QuerySnapshot> fetchSubscribedLatestMyPosts({@required String userID});
  Future<QuerySnapshot> fetchMyPostLikes({@required String postID});
  Future<QuerySnapshot> fetchMyPosts({@required Post lastVisibleMyPost});
  Future<QuerySnapshot> fetchProfileMyPosts(
      {@required Post lastVisibleMyPost, @required String userID});
  Future<DocumentReference> createMyPost({@required Map<String, dynamic> data});
}

class MyPostProvider implements IMyPostProvider {
  PostRepository _postRepository;

  MyPostProvider() {
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

  Future<DocumentSnapshot> fetchMyPost({@required String postID}) async {
    return await _postRepository.fetchPost(postID: postID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestMyPosts(
      {@required String userID}) async {
    return await _postRepository.fetchSubscribedLatestPosts(userID: userID);
  }

  Future<QuerySnapshot> fetchMyPostLikes({@required String postID}) async {
    return await _postRepository.fetchPostLikes(postID: postID);
  }

  Future<QuerySnapshot> fetchMyPosts({@required Post lastVisibleMyPost}) async {
    return await _postRepository.fetchPosts(lastVisiblePost: lastVisibleMyPost);
  }

  Future<QuerySnapshot> fetchProfileMyPosts(
      {@required Post lastVisibleMyPost, @required String userID}) async {
    return await _postRepository.fetchProfilePosts(
        lastVisiblePost: lastVisibleMyPost, userID: userID);
  }

  Future<DocumentReference> createMyPost(
      {@required Map<String, dynamic> data}) async {
    return await _postRepository.createPost(data: data);
  }
}

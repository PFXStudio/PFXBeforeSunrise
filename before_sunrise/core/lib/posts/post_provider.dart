import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IPostProvider {
  Future<bool> isLiked(
      {@required String category,
      @required String postID,
      @required String userID});
  Future<void> addToLike(
      {@required String category,
      @required String postID,
      @required String userID});
  Future<void> removeFromLike(
      {@required String category,
      @required String postID,
      @required String userID});
  Future<bool> isReporter(
      {@required String category,
      @required String postID,
      @required String userID});
  Future<void> addToReporter(
      {@required String category,
      @required String postID,
      @required String userID});
  Future<void> removeFromReporter(
      {@required String category,
      @required String postID,
      @required String userID});
  Future<bool> isViewer(
      {@required String category,
      @required String postID,
      @required String userID});
  Future<void> addToViewer(
      {@required String category,
      @required String postID,
      @required String userID});

  Future<DocumentSnapshot> fetchPost(
      {@required String category, @required String postID});
  Future<QuerySnapshot> fetchSubscribedLatestPosts(
      {@required String category, @required String userID});
  Future<QuerySnapshot> fetchPostLikes(
      {@required String category, @required String postID});
  Future<QuerySnapshot> fetchPosts(
      {@required String category, @required Post lastVisiblePost});
  Future<QuerySnapshot> fetchProfilePosts(
      {@required String category,
      @required Post lastVisiblePost,
      @required String userID});
  Future<DocumentReference> createPost(
      {@required String category, @required Map<String, dynamic> data});
}

class PostProvider implements IPostProvider {
  PostRepository _postRepository;

  PostProvider() {
    _postRepository = PostRepository();
  }

  Future<bool> isLiked(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.isLiked(
        category: category, postID: postID, userID: userID);
  }

  Future<void> addToLike(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.addToLike(
        category: category, postID: postID, userID: userID);
  }

  Future<void> removeFromLike(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.removeFromLike(
        category: category, postID: postID, userID: userID);
  }

  Future<bool> isReporter(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.isReporter(
        category: category, postID: postID, userID: userID);
  }

  Future<void> addToReporter(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.addToReporter(
        category: category, postID: postID, userID: userID);
  }

  Future<void> removeFromReporter(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.removeFromReporter(
        category: category, postID: postID, userID: userID);
  }

  Future<bool> isViewer(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.isViewer(
        category: category, postID: postID, userID: userID);
  }

  Future<void> addToViewer(
      {@required String category,
      @required String postID,
      @required String userID}) async {
    return await _postRepository.addToViewer(
        category: category, postID: postID, userID: userID);
  }

  Future<DocumentSnapshot> fetchPost(
      {@required String category, @required String postID}) async {
    return await _postRepository.fetchPost(category: category, postID: postID);
  }

  Future<QuerySnapshot> fetchSubscribedLatestPosts(
      {@required String category, @required String userID}) async {
    return await _postRepository.fetchSubscribedLatestPosts(
        category: category, userID: userID);
  }

  Future<QuerySnapshot> fetchPostLikes(
      {@required String category, @required String postID}) async {
    return await _postRepository.fetchPostLikes(
        category: category, postID: postID);
  }

  Future<QuerySnapshot> fetchPosts(
      {@required String category, @required Post lastVisiblePost}) async {
    return await _postRepository.fetchPosts(
        category: category, lastVisiblePost: lastVisiblePost);
  }

  Future<QuerySnapshot> fetchProfilePosts(
      {@required String category,
      @required Post lastVisiblePost,
      @required String userID}) async {
    return await _postRepository.fetchProfilePosts(
        category: category, lastVisiblePost: lastVisiblePost, userID: userID);
  }

  Future<DocumentReference> createPost(
      {@required String category, @required Map<String, dynamic> data}) async {
    return await _postRepository.createPost(category: category, data: data);
  }
}

import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IShardsProvider {
  Future<DocumentSnapshot> postLikedCount({@required String postID});
  Future<void> increasePostLikeCount({@required String postID});
  Future<void> decreasePostLikeCount({@required String postID});

  Future<DocumentSnapshot> commentLikedCount({@required String commentID});
  Future<void> increaseCommentLikeCount({@required String commentID});
  Future<void> decreaseCommentLikeCount({@required String commentID});
}

class ShardsProvider implements IShardsProvider {
  ShardsRepository _shardsRepository;

  ShardsProvider() {
    _shardsRepository = ShardsRepository();
  }

  Future<DocumentSnapshot> postLikedCount({@required String postID}) async {
    return await _shardsRepository.postLikedCount(postID: postID);
  }

  Future<void> increasePostLikeCount({@required String postID}) async {
    return await _shardsRepository.increasePostLikeCount(postID: postID);
  }

  Future<void> decreasePostLikeCount({@required String postID}) async {
    return await _shardsRepository.decreasePostLikeCount(postID: postID);
  }

  Future<DocumentSnapshot> commentLikedCount(
      {@required String commentID}) async {
    return await _shardsRepository.commentLikedCount(commentID: commentID);
  }

  Future<void> increaseCommentLikeCount({@required String commentID}) async {
    return await _shardsRepository.increaseCommentLikeCount(
        commentID: commentID);
  }

  Future<void> decreaseCommentLikeCount({@required String commentID}) async {
    return await _shardsRepository.decreaseCommentLikeCount(
        commentID: commentID);
  }
}

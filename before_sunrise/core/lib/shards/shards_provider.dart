import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IShardsProvider {
  Future<void> removePostLikeCount({@required String postID});
  Future<DocumentSnapshot> postLikeCount({@required String postID});
  Future<void> increasePostLikeCount(
      {@required String category, @required String postID});
  Future<void> decreasePostLikeCount(
      {@required String category, @required String postID});
  Future<void> removeCommentCount({@required String postID});
  Future<DocumentSnapshot> commentCount({@required String postID});
  Future<void> increaseCommentCount(
      {@required String category, @required String postID});
  Future<void> decreaseCommentCount(
      {@required String category, @required String postID});
  Future<void> removeReportCount({@required String postID});
  Future<DocumentSnapshot> reportCount({@required String postID});
  Future<void> increaseReportCount(
      {@required String category, @required String postID});
  Future<void> decreaseReportCount(
      {@required String category, @required String postID});
  Future<void> removeViewCount({@required String postID});
  Future<DocumentSnapshot> viewCount({@required String postID});
  Future<void> increaseViewCount(
      {@required String category, @required String postID});
  Future<void> decreaseViewCount(
      {@required String category, @required String postID});
}

class ShardsProvider implements IShardsProvider {
  ShardsRepository _shardsRepository;

  ShardsProvider() {
    _shardsRepository = ShardsRepository();
  }

  Future<void> removePostLikeCount({@required String postID}) async {
    return await _shardsRepository.removePostLikeCount(postID: postID);
  }

  Future<DocumentSnapshot> postLikeCount({@required String postID}) async {
    return await _shardsRepository.postLikeCount(postID: postID);
  }

  Future<void> increasePostLikeCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.increasePostLikeCount(
        category: category, postID: postID);
  }

  Future<void> decreasePostLikeCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.decreasePostLikeCount(
        category: category, postID: postID);
  }

  Future<void> removeCommentCount({@required String postID}) async {
    return await _shardsRepository.removeCommentCount(postID: postID);
  }

  Future<DocumentSnapshot> commentCount({@required String postID}) async {
    return await _shardsRepository.commentCount(postID: postID);
  }

  Future<void> increaseCommentCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.increaseCommentCount(
        category: category, postID: postID);
  }

  Future<void> decreaseCommentCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.decreaseCommentCount(
        category: category, postID: postID);
  }

  Future<void> removeReportCount({@required String postID}) async {
    return await _shardsRepository.removeReportCount(postID: postID);
  }

  Future<DocumentSnapshot> reportCount({@required String postID}) async {
    return await _shardsRepository.reportCount(postID: postID);
  }

  Future<void> increaseReportCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.increaseReportCount(
        category: category, postID: postID);
  }

  Future<void> decreaseReportCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.decreaseReportCount(
        category: category, postID: postID);
  }

  Future<void> removeViewCount({@required String postID}) async {
    return await _shardsRepository.removeViewCount(postID: postID);
  }

  Future<DocumentSnapshot> viewCount({@required String postID}) async {
    return await _shardsRepository.viewCount(postID: postID);
  }

  Future<void> increaseViewCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.increaseViewCount(
        category: category, postID: postID);
  }

  Future<void> decreaseViewCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.decreaseViewCount(
        category: category, postID: postID);
  }
}

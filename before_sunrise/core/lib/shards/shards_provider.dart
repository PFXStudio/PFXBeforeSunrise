import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IShardsProvider {
  Future<void> removePostCounter({@required String postID});
  Future<DocumentSnapshot> postLikedCount({@required String postID});
  Future<void> increasePostLikeCount(
      {@required String category, @required String postID});
  Future<void> decreasePostLikeCount(
      {@required String category, @required String postID});
  Future<DocumentSnapshot> commentCount({@required String postID});
  Future<void> increaseCommentCount(
      {@required String category, @required String postID});
  Future<void> decreaseCommentCount(
      {@required String category, @required String postID});

  Future<DocumentSnapshot> reporterCount({@required String postID});
  Future<void> increaseReporterCount(
      {@required String category, @required String postID});
  Future<void> decreaseReporterCount(
      {@required String category, @required String postID});

  Future<DocumentSnapshot> viewerCount({@required String postID});
  Future<void> increaseViewerCount(
      {@required String category, @required String postID});
}

class ShardsProvider implements IShardsProvider {
  ShardsRepository _shardsRepository;

  ShardsProvider() {
    _shardsRepository = ShardsRepository();
  }

  Future<void> removePostCounter({@required String postID}) async {
    return await _shardsRepository.removePostCounter(postID: postID);
  }

  Future<DocumentSnapshot> postLikedCount({@required String postID}) async {
    return await _shardsRepository.postLikedCount(postID: postID);
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

  Future<DocumentSnapshot> reporterCount({@required String postID}) async {
    return await _shardsRepository.reporterCount(postID: postID);
  }

  Future<void> increaseReporterCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.increaseReporterCount(
        category: category, postID: postID);
  }

  Future<void> decreaseReporterCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.decreaseReporterCount(
        category: category, postID: postID);
  }

  Future<DocumentSnapshot> viewerCount({@required String postID}) async {
    return await _shardsRepository.viewerCount(postID: postID);
  }

  Future<void> increaseViewerCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.increaseViewerCount(
        category: category, postID: postID);
  }

  Future<void> decreaseViewerCount(
      {@required String category, @required String postID}) async {
    return await _shardsRepository.decreaseViewerCount(
        category: category, postID: postID);
  }
}

import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IShardsProvider {
  Future<DocumentSnapshot> likedCount({@required String postID});
  Future<void> increaseLikeCount({@required String postID});
  Future<void> decreaseLikeCount({@required String postID});
}

class ShardsProvider implements IShardsProvider {
  ShardsRepository _shardsRepository;

  ShardsProvider() {
    _shardsRepository = ShardsRepository();
  }

  Future<DocumentSnapshot> likedCount({@required String postID}) async {
    return await _shardsRepository.likedCount(postID: postID);
  }

  Future<void> increaseLikeCount({@required String postID}) async {
    return await _shardsRepository.increaseLikeCount(postID: postID);
  }

  Future<void> decreaseLikeCount({@required String postID}) async {
    return await _shardsRepository.decreaseLikeCount(postID: postID);
  }
}

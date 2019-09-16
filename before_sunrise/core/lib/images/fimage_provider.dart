import 'package:core/import.dart';

// 정의 한 것만 접근 하도록 인터페이스 관리
abstract class IFImageProvider {
  Future<String> saveProfileImage(
      {@required String userID, @required ByteData imageData});
  Future<String> uploadCategoryImage({@required ByteData imageData});
  Future<List<String>> uploadPostImages({
    @required String imageFolder,
    @required List<ByteData> byteDatas,
  });
  Future<List<String>> uploadCommentImages({
    @required String imageFolder,
    @required List<ByteData> byteDatas,
  });
  Future<void> removeImage({@required String imageUrl});
}

class FImageProvider implements IFImageProvider {
  ImageRepository _imageRepository;

  FImageProvider() {
    _imageRepository = ImageRepository();
  }

  Future<String> saveProfileImage(
      {@required String userID, @required ByteData imageData}) async {
    return await _imageRepository.saveProfileImage(
        userID: userID, imageData: imageData);
  }

  Future<String> uploadCategoryImage({@required ByteData imageData}) async {
    return await _imageRepository.uploadCategoryImage(imageData: imageData);
  }

  Future<List<String>> uploadPostImages({
    @required String imageFolder,
    @required List<ByteData> byteDatas,
  }) async {
    return await _imageRepository.uploadPostImages(
        imageFolder: imageFolder, byteDatas: byteDatas);
  }

  Future<void> removeImage({@required String imageUrl}) async {
    return await _imageRepository.removeImage(imageUrl: imageUrl);
  }

  @override
  Future<List<String>> uploadCommentImages(
      {String imageFolder, List<ByteData> byteDatas}) async {
    return await _imageRepository.uploadCommentImages(
        imageFolder: imageFolder, byteDatas: byteDatas);
  }
}

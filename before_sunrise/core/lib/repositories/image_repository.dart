import 'package:core/import.dart';

class ImageRepository {
  final FirebaseStorage _firebaseStorage;

  ImageRepository() : _firebaseStorage = FirebaseStorage.instance;

  Future<Uint8List> _compressFile(
      {@required List<int> listData, int quality = 40}) async {
    List<int> compressedImageData =
        await FlutterImageCompress.compressWithList(listData, quality: quality);

    return Uint8List.fromList(compressedImageData);
  }

  Future<String> saveProfileImage(
      {@required String userID, @required ByteData imageData}) async {
    final String fileName = Config().root() + "/profiles/$userID/$userID";

    List<int> listData = imageData.buffer.asUint8List();

    // compress file
    Uint8List compressedFile = await _compressFile(listData: listData);

    StorageReference reference = _firebaseStorage.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(compressedFile);
    StorageTaskSnapshot storageTaskSnapshot;

    // Release the image data
    // asset.releaseOriginal();

    StorageTaskSnapshot snapshot = await uploadTask.onComplete.timeout(
        const Duration(seconds: 60),
        onTimeout: () =>
            throw ('Upload could not be completed. Operation timeout'));

    if (snapshot.error == null) {
      storageTaskSnapshot = snapshot;
      return await storageTaskSnapshot.ref.getDownloadURL();
    } else {
      throw ('An error occured while uploading image. Upload error');
    }
  }

  Future<String> uploadCategoryImage({@required ByteData imageData}) async {
    final uuid = Uuid();
    final String fileName = Config().root() + "/categories/${uuid.v1()}";
    List<int> listData = imageData.buffer.asUint8List();

    // compress file
    Uint8List compressedFile =
        await _compressFile(listData: listData, quality: 30);

    StorageReference reference = _firebaseStorage.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(compressedFile);
    StorageTaskSnapshot storageTaskSnapshot;

    // Release the image data
    // asset.releaseOriginal();

    StorageTaskSnapshot snapshot = await uploadTask.onComplete.timeout(
        const Duration(seconds: 60),
        onTimeout: () =>
            throw ('Upload could not be completed. Operation timeout'));

    if (snapshot.error == null) {
      storageTaskSnapshot = snapshot;
      return await storageTaskSnapshot.ref.getDownloadURL();
    } else {
      throw ('An error occured while uploading image. Upload error');
    }
  }

  Future<List<String>> uploadPostImages({
    @required String imageFolder,
    @required List<ByteData> byteDatas,
  }) async {
    List<String> uploadUrls = [];

    await Future.wait(
            byteDatas.map((ByteData byteData) async {
              List<int> listData = byteData.buffer.asUint8List();

              // compress file
              Uint8List compressedFile =
                  await _compressFile(listData: listData);

              final uuid = Uuid();
              final String fileName =
                  Config().root() + "/$imageFolder/${uuid.v1()}";

              StorageReference reference =
                  FirebaseStorage.instance.ref().child(fileName);
              StorageUploadTask uploadTask = reference.putData(compressedFile);
              StorageTaskSnapshot storageTaskSnapshot;

              // Release the image data
              // asset.releaseOriginal();

              StorageTaskSnapshot snapshot = await uploadTask.onComplete.timeout(
                  const Duration(seconds: 180),
                  onTimeout: () =>
                      throw ('Upload could not be completed. Operation timeout'));

              if (snapshot.error == null) {
                storageTaskSnapshot = snapshot;
                final String downloadUrl =
                    await storageTaskSnapshot.ref.getDownloadURL();

                uploadUrls.add(downloadUrl);
                print('Upload success');
              } else {
                print('Error from image repo ${snapshot.error.toString()}');
                throw ('An error occured while uploading image. Upload error');
              }
            }),
            eagerError: true,
            cleanUp: (_) {
              print('eager cleaned up');
            })
        .timeout(const Duration(seconds: 180),
            onTimeout: () =>
                throw ('Upload could not be completed. Operation timeout'));

    return uploadUrls;
  }

  Future<List<String>> uploadCommentImages({
    @required String imageFolder,
    @required List<ByteData> byteDatas,
  }) async {
    List<String> uploadUrls = [];

    await Future.wait(
            byteDatas.map((ByteData byteData) async {
              List<int> listData = byteData.buffer.asUint8List();

              // compress file
              Uint8List compressedFile =
                  await _compressFile(listData: listData);

              final uuid = Uuid();
              final String fileName =
                  Config().root() + "/$imageFolder/${uuid.v1()}";

              StorageReference reference =
                  FirebaseStorage.instance.ref().child(fileName);
              StorageUploadTask uploadTask = reference.putData(compressedFile);
              StorageTaskSnapshot storageTaskSnapshot;

              // Release the image data
              // asset.releaseOriginal();

              StorageTaskSnapshot snapshot = await uploadTask.onComplete.timeout(
                  const Duration(seconds: 180),
                  onTimeout: () =>
                      throw ('Upload could not be completed. Operation timeout'));

              if (snapshot.error == null) {
                storageTaskSnapshot = snapshot;
                final String downloadUrl =
                    await storageTaskSnapshot.ref.getDownloadURL();

                uploadUrls.add(downloadUrl);
                print('Upload success');
              } else {
                print('Error from image repo ${snapshot.error.toString()}');
                throw ('An error occured while uploading image. Upload error');
              }
            }),
            eagerError: true,
            cleanUp: (_) {
              print('eager cleaned up');
            })
        .timeout(const Duration(seconds: 180),
            onTimeout: () =>
                throw ('Upload could not be completed. Operation timeout'));

    return uploadUrls;
  }

  Future<void> removeImage({@required String imageUrl}) async {
    if (imageUrl.isNotEmpty) {
      final StorageReference reference =
          await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
      if (reference == null) {
        return null;
      }

      return reference.delete();
    }
  }
}

import 'dart:ui';

import 'package:before_sunrise/import.dart';
import 'package:image/image.dart' as libImage;

void downloadAllImages(List<dynamic> imageUrls,
    void Function(Map<String, ByteData>) callback) async {
  assert(callback != null);
  if (imageUrls == null || imageUrls.length <= 0) {
    callback(null);
    return;
  }

  Map<String, ByteData> editImageMap = {};
  for (String url in imageUrls) {
    final image = CachedNetworkImageProvider(url);
    final key = await image.obtainKey(ImageConfiguration());
    final load = image.load(key);

    // final image = NetworkImage(url);
    // final key = await image.obtainKey(ImageConfiguration());
    // final load = image.load(key);
    load.addListener(
      ImageStreamListener((listener, err) async {
        final byteData =
            await listener.image.toByteData(format: ImageByteFormat.png);
        final bytes = byteData.buffer.asUint8List();
        final originalImage = libImage.Image.fromBytes(
            listener.image.width, listener.image.height, bytes);
        final originalBytes = originalImage.getBytes();
        var originalByteData = new ByteData.view(originalBytes.buffer);

        editImageMap[url] = originalByteData;
        print("download $url");
        if (imageUrls.length != editImageMap.keys.length) {
          return;
        }

        callback(editImageMap);
      }),
    );
  }
}

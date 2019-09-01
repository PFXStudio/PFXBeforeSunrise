import 'dart:ui' as ui;
import 'package:before_sunrise/import.dart';

class ImageDetailScreen extends StatelessWidget {
  final String tag;
  final String imageUrl;

  ImageDetailScreen(this.tag, this.imageUrl); // 생성자를 통해 imageUrl 을 전달받음

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(),
          body: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.white.withOpacity(0.1),
              child: Center(
                  child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, imageUrl) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, imageUrl, error) =>
                    Center(child: Icon(Icons.error)),
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Hero(
                    tag: tag,
                    child: Container(
                      decoration: BoxDecoration(
                        image:
                            DecorationImage(image: image, fit: BoxFit.fitWidth),
                      ),
                    ),
                  );
                },
              )),
            ),
          ));
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }
}

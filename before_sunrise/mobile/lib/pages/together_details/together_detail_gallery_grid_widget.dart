import 'package:before_sunrise/import.dart';

class TogetherDetailGalleryGridWidget extends StatelessWidget {
  TogetherDetailGalleryGridWidget(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(),
          _Grid(together),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        LocalizableLoader.of(context).text("board_gallery_title"),
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  _Grid(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25 / 1,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      children: List.generate(together.imageUrls.length, (index) {
        return _GalleryImage(together.imageUrls[index], index, () {
          print("taped image!!");
        });
      }),
    );
  }
}

class _GalleryImage extends StatelessWidget {
  _GalleryImage(this.url, this.index, this.onTap);
  final String url;
  final int index;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = const BoxDecoration(
      boxShadow: [
        BoxShadow(
          spreadRadius: 2.0,
          blurRadius: 5.0,
          offset: Offset(2.0, 2.0),
          color: Colors.black38,
        ),
      ],
    );

    return Stack(children: <Widget>[
      Container(
          margin: const EdgeInsets.all(8.0),
          decoration: decoration,
          child: FadeInImage.assetNetwork(
            placeholder: DefineImages.icon_fake_8_path,
            image: url,
            fit: BoxFit.cover,
          )),
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: GestureDetector(
            onTap: onTap,
            child: Hero(
              tag: index,
              child: Image.asset(DefineImages.icon_fake_8_path, height: 80.0),
            ),
          )),
        ],
      ),
    ]);
  }
}

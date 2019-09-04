import 'package:before_sunrise/import.dart';

@visibleForTesting
Function(String) launchTrailerVideo = (url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
};

class TogetherDetailPoster extends StatelessWidget {
  static const Key playButtonKey = const Key('playButton');

  TogetherDetailPoster({
    @required this.together,
    this.size,
    this.displayPlayButton = false,
  });

  final Together together;
  final Size size;
  final bool displayPlayButton;

  Widget _buildPlayButton() =>
      displayPlayButton && together.youtubeUrl.isNotEmpty
          ? _PlayButton(together)
          : null;

  Widget _buildPosterImage() =>
      (together.imageUrls != null && together.imageUrls.isNotEmpty == true)
          ? FadeInImage.assetNetwork(
              placeholder: DefineImages.bgnd_main_220_path,
              image: together.imageUrls.first,
              width: size?.width,
              height: size?.height,
              fadeInDuration: const Duration(milliseconds: 300),
              fit: BoxFit.cover,
            )
          : null;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      const Icon(
        FontAwesomeIcons.image,
        color: Colors.white24,
        size: 44.0,
      ),
    ];

    addIfNonNull(_buildPosterImage(), content);
    addIfNonNull(_buildPlayButton(), content);

    return Container(
      decoration: _buildDecorations(),
      width: size?.width,
      height: size?.height,
      child: Stack(
        alignment: Alignment.center,
        children: content,
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  _PlayButton(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black38,
      ),
      child: Material(
        type: MaterialType.circle,
        color: Colors.transparent,
        child: IconButton(
          key: TogetherDetailPoster.playButtonKey,
          padding: EdgeInsets.zero,
          icon: const Icon(FontAwesomeIcons.playCircle),
          iconSize: 42.0,
          color: Colors.white.withOpacity(0.8),
          onPressed: () {
            final url = together.youtubeUrl;
            launchTrailerVideo(url);
          },
        ),
      ),
    );
  }
}

BoxDecoration _buildDecorations() {
  return const BoxDecoration(
    boxShadow: [
      BoxShadow(
        offset: Offset(1.0, 1.0),
        spreadRadius: 1.0,
        blurRadius: 2.0,
        color: Colors.black38,
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Color(0xFF222222),
        Color(0xFF424242),
      ],
    ),
  );
}

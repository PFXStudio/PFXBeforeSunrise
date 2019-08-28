import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

@visibleForTesting
Function(String) launchTrailerVideo = (url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
};

class TogetherPoster extends StatelessWidget {
  static const Key playButtonKey = const Key('playButton');

  TogetherPoster({
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
      (together.imageUrls != null && together.imageUrls.length > 0)
          ? FadeInImage.assetNetwork(
              placeholder: "assets/images/1x1_transparent.png",
              image: together.imageUrls.first,
              width: 260,
              height: 260,
              fadeInDuration: const Duration(milliseconds: 300),
              fit: BoxFit.cover,
            )
          : null;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      const Icon(
        FontAwesomeIcons.cocktail,
        color: Colors.black54,
        size: 32.0,
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
          key: TogetherPoster.playButtonKey,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.play_circle_outline),
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
    gradient:
        LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
            // colors: [
            //   Color(0xFF222222),
            //   Color(0xFF424242),
            // ],
            colors: [MainTheme.bgndColor, MainTheme.liteBgndColor]),
  );
}

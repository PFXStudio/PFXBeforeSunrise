import 'dart:ui' as ui;
import 'package:before_sunrise/import.dart';

class TogetherDetailBackdropPhotoWidget extends StatelessWidget {
  const TogetherDetailBackdropPhotoWidget({
    @required this.together,
    @required this.scrollEffects,
  });

  final Together together;
  final TogetherDetailScrollEffects scrollEffects;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          _BackdropPhoto(together, scrollEffects),
          _BlurOverlay(scrollEffects),
          _InsetShadow(),
        ],
      ),
    );
  }
}

class _BackdropPhoto extends StatelessWidget {
  _BackdropPhoto(this.together, this.scrollEffects);
  final Together together;
  final TogetherDetailScrollEffects scrollEffects;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _PlaceholderBackground(scrollEffects.backdropHeight),
        _BackdropImage(together, scrollEffects),
      ],
    );
  }
}

class _PlaceholderBackground extends StatelessWidget {
  _PlaceholderBackground(this.height);
  final double height;

  @override
  Widget build(BuildContext context) {
    final decoration = const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color(0xFF222222),
          Color(0xFF424242),
        ],
      ),
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: decoration,
      child: const Center(
        child: Icon(
          Icons.theaters,
          color: Colors.white30,
          size: 96.0,
        ),
      ),
    );
  }
}

class _BackdropImage extends StatelessWidget {
  _BackdropImage(this.together, this.scrollEffects);
  final Together together;
  final TogetherDetailScrollEffects scrollEffects;

  String get photoUrl =>
      together.profile.imageUrl != null && together.profile.imageUrl.length > 0
          ? together.profile.imageUrl
          : "";

  @override
  Widget build(BuildContext context) {
    if (photoUrl == null) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: scrollEffects.backdropHeight,
      child: FadeInImage.assetNetwork(
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: DefineImages.bgnd_main_path,
        image: photoUrl,
        width: screenWidth,
        height: scrollEffects.backdropHeight,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _BlurOverlay extends StatelessWidget {
  _BlurOverlay(this.scrollEffects);
  final TogetherDetailScrollEffects scrollEffects;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: scrollEffects.backdropOverlayBlur,
        sigmaY: scrollEffects.backdropOverlayBlur,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: scrollEffects.backdropHeight,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(
            scrollEffects.backdropOverlayOpacity * 0.4,
          ),
        ),
      ),
    );
  }
}

class _InsetShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: -8.0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: SizedBox(
          width: screenWidth,
          height: 10.0,
        ),
      ),
    );
  }
}

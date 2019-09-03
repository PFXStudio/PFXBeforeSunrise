import 'package:before_sunrise/import.dart';

class MainTheme {
  const MainTheme();

  static const Color bgndColor = const Color(0xFFE55D57);
  static const Color liteBgndColor = const Color(0xffF8C5B8);
  static const Color activeIndicatorColor = const Color(0xFFE55D57);
  static const Color pivotColor = const Color(0xFFe8b730);
  static const Color enabledButtonColor = const Color(0xFFee6d66);
  static const Color disabledButtonColor = const Color(0x66e4e4e4);
  static const Color appBarColor = const Color(0xFFE55D57);
  static const Color enabledIconColor = Colors.white;

  static const Color gradientStartColor = const Color(0xFFfa6464);
  static const Color gradientEndColor = const Color(0xFF2d122d);
  static const primaryLinearGradient = const LinearGradient(
      colors: const [gradientStartColor, gradientEndColor],
      stops: const [0.0, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.clamp);

  static const buttonLinearGradient = const LinearGradient(
      colors: const [const Color(0xFFff9494), const Color(0xFFcf4242)],
      stops: const [0.0, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.clamp);

  static const EdgeInsets edgeInsets = EdgeInsets.all(20);

  static const TextStyle navTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
    color: Colors.white,
  );

  static const TextStyle nickNameStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white);

  static const TextStyle simpleNickNameStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black);

  static const TextStyle titleTextStyle = TextStyle(
      fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87);

  static const TextStyle barTitleTextStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87);

  static const TextStyle subTitleTextStyle = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87);

  static const TextStyle contentsTextStyle =
      TextStyle(fontSize: 13, color: Colors.black87);

  static const TextStyle timeTextStyle =
      TextStyle(fontSize: 13, color: Colors.black54);
}

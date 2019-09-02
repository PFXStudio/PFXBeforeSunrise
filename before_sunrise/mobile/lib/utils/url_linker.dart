import 'package:before_sunrise/import.dart';

Function(String) launchTrailerVideo = (url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
};

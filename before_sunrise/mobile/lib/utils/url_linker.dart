import 'package:before_sunrise/import.dart';

Function(String) launchVideo = (url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
};

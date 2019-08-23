import 'package:before_sunrise/import.dart';

class LatestPostPage extends StatelessWidget {
  static const String routeName = "/latestPost";

  @override
  Widget build(BuildContext context) {
    var _postBloc = new PostBloc();
    return LatestPostScreen(postBloc: _postBloc);
  }
}

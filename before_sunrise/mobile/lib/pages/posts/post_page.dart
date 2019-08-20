import 'package:before_sunrise/import.dart';

class PostPage extends StatelessWidget {
  static const String routeName = "/post";

  @override
  Widget build(BuildContext context) {
    var _postBloc = new PostBloc();
    return PostScreen(postBloc: _postBloc);
  }
}

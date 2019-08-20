import 'package:before_sunrise/import.dart';

class FreePostPage extends StatelessWidget {
  static const String routeName = "/freePost";

  @override
  Widget build(BuildContext context) {
    var _postBloc = new PostBloc();
    return FreePostScreen(postBloc: _postBloc);
  }
}

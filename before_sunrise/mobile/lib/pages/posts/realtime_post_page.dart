import 'package:before_sunrise/import.dart';

class RealtimePostPage extends StatelessWidget {
  static const String routeName = "/realtimePost";

  @override
  Widget build(BuildContext context) {
    var _postBloc = new PostBloc();
    return RealtimePostScreen(postBloc: _postBloc);
  }
}

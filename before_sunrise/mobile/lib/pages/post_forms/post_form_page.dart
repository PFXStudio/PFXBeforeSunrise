import 'package:before_sunrise/import.dart';

class PostFormPage extends StatelessWidget {
  static const String routeName = "/postForm";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PostBloc _postBloc = new PostBloc();
  PostFormScreen _postFormScreen;
  @override
  Widget build(BuildContext context) {
    _postFormScreen = PostFormScreen(postBloc: _postBloc);

    return Scaffold(
      appBar: PostFormTopBar(),
      key: _scaffoldKey,
      body: _postFormScreen,
    );
  }
}

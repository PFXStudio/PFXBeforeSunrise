import 'package:before_sunrise/import.dart';

class PostPage extends StatelessWidget {
  PostPage({@required this.category});
  static const String routeName = "/post";
  final String category;
  @override
  Widget build(BuildContext context) {
    var _postBloc = new PostBloc();
    return PostScreen(category: category, postBloc: _postBloc);
  }
}

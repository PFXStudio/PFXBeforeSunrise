import 'package:before_sunrise/import.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    Key key,
    @required PostBloc postBloc,
  })  : _postBloc = postBloc,
        super(key: key);

  final PostBloc _postBloc;

  @override
  PostScreenState createState() {
    return new PostScreenState(_postBloc);
  }
}

class PostScreenState extends State<PostScreen> {
  final PostBloc _postBloc;
  PostScreenState(this._postBloc);

  @override
  void initState() {
    super.initState();
    this._postBloc.dispatch(LoadPostEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget._postBloc,
        listener: (context, state) async {},
        child: BlocBuilder<PostBloc, PostState>(
            bloc: widget._postBloc,
            builder: (
              BuildContext context,
              PostState currentState,
            ) {
              if (currentState is UnPostState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (currentState is ErrorPostState) {
                return new Container(
                    child: new Center(
                  child: new Text(currentState.errorMessage ?? 'Error'),
                ));
              }
              return new Container(
                  child: new Center(
                child: new Text("В разработке"),
              ));
            }));
  }
}

import 'package:before_sunrise/import.dart';

class TogetherScreen extends StatefulWidget {
  const TogetherScreen({
    Key key,
    @required TogetherBloc togetherBloc,
  })  : _togetherBloc = togetherBloc,
        super(key: key);

  final TogetherBloc _togetherBloc;

  @override
  TogetherScreenState createState() {
    return new TogetherScreenState(_togetherBloc);
  }
}

class TogetherScreenState extends State<TogetherScreen> {
  final TogetherBloc _togetherBloc;
  TogetherScreenState(this._togetherBloc);

  @override
  void initState() {
    super.initState();
    this._togetherBloc.dispatch(LoadTogetherEvent(post: null));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TogetherBloc, TogetherState>(
        bloc: widget._togetherBloc,
        builder: (
          BuildContext context,
          TogetherState currentState,
        ) {
          if (currentState is UnTogetherState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorTogetherState) {
            return new Container(
                child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error'),
            ));
          }
          return new Container(
              child: new Center(
            child: new Text("В разработке"),
          ));
        });
  }
}

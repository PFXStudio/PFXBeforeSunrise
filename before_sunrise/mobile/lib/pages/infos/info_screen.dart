import 'package:before_sunrise/import.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    Key key,
    @required InfoBloc infoBloc,
  })  : _infoBloc = infoBloc,
        super(key: key);

  final InfoBloc _infoBloc;

  @override
  InfoScreenState createState() {
    return new InfoScreenState(_infoBloc);
  }
}

class InfoScreenState extends State<InfoScreen> {
  final InfoBloc _infoBloc;
  InfoScreenState(this._infoBloc);

  @override
  void initState() {
    super.initState();
    this._infoBloc.dispatch(LoadInfoEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Info"),
        ),
        body: BlocBuilder<InfoBloc, InfoState>(
            bloc: widget._infoBloc,
            builder: (
              BuildContext context,
              InfoState currentState,
            ) {
              if (currentState is UnInfoState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (currentState is ErrorInfoState) {
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

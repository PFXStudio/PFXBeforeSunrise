import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/togethers/together_list_page.dart';

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
    this._togetherBloc.dispatch(LoadTogetherEvent(dateTime: DateTime.now()));
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
          if (currentState is FetchedTogetherState) {
            TogetherCollection togetherCollection =
                currentState.togetherCollection;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TogetherDateSelector(togetherCollection, (dateTime) {
                  print(dateTime);
                  widget._togetherBloc
                      .dispatch(LoadTogetherEvent(dateTime: dateTime));
                }),
                Expanded(
                  child:
                      TogetherListPage(togethers: togetherCollection.togethers),
                ),
              ],
            );
          }

          if (currentState is ErrorTogetherState) {
            return Container(child: Text(currentState.errorMessage.toString()));
          }

          return Container();
        });
  }
}

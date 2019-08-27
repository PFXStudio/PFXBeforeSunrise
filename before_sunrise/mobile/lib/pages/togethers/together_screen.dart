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
  DateTime selectedDate;

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
    DateTime currentDateTime = DateTime.now();
    List<DateTime> dates = List.generate(6, (index) {
      var addDateTime = currentDateTime.add(Duration(days: index));
      return DateTime(addDateTime.year, addDateTime.month, addDateTime.day);
    });

    if (selectedDate == null) {
      selectedDate = dates.first;
    }

    print(selectedDate);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TogetherDateSelector(dates, selectedDate, (dateTime) {
        selectedDate = dateTime;
        widget._togetherBloc.dispatch(LoadTogetherEvent(dateTime: dateTime));
      }),
      Expanded(
        child: BlocBuilder<TogetherBloc, TogetherState>(
            bloc: widget._togetherBloc,
            builder: (
              BuildContext context,
              TogetherState currentState,
            ) {
              if (currentState is ErrorTogetherState) {
                return Container(
                    child: Text(currentState.errorMessage.toString()));
              }

              TogetherCollection togetherCollection;
              if (currentState is FetchedTogetherState) {
                togetherCollection = currentState.togetherCollection;
              }

              if (currentState is EmptyTogetherState) {
                togetherCollection = currentState.togetherCollection;
              }

              if (togetherCollection == null) {
                return Container();
              }

              return TogetherListPage(togethers: togetherCollection.togethers);
            }),
      )
    ]);
  }
}

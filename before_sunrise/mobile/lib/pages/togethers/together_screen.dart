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
  DateTime _selectedDate;
  List<Together> _togethers = List<Together>();
  bool _enabeldMorePosts = false;

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

    if (_selectedDate == null) {
      _selectedDate = dates.first;
    }

    print(_selectedDate);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TogetherDateSelector(dates, _selectedDate, (dateTime) {
        _selectedDate = dateTime;
        _enabeldMorePosts = false;
        _togethers.clear();
        widget._togetherBloc.dispatch(LoadTogetherEvent(dateTime: dateTime));
      }),
      Expanded(
        child: BlocListener(
            bloc: widget._togetherBloc,
            listener: (context, state) async {
              if (state is SuccessTogetherState ||
                  state is SuccessRemoveTogetherState) {
                _enabeldMorePosts = false;
                _togethers.clear();
                this._togetherBloc.dispatch(LoadTogetherEvent(
                    dateTime: DateTime.now(), lastVisibleTogether: null));
              }
            },
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

                  if (currentState is FetchingTogetherState) {
                    if (_togethers.length == 0) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return _buildPosts(null, true);
                  }

                  List<Together> collections = null;
                  if (currentState is FetchedTogetherState) {
                    collections = currentState.togetherCollection.togethers;
                  }

                  if (currentState is EmptyTogetherState) {
                    _enabeldMorePosts = false;
                  }

                  return _buildPosts(collections, false);
                })),
      )
    ]);
  }

  Widget _buildPosts(List<Together> togethers, bool isBottomLoading) {
    _enabeldMorePosts = false;
    if (togethers != null) {
      if (togethers.length >= CoreConst.maxLoadPostCount) {
        _enabeldMorePosts = true;
      }

      if (togethers.length > 0) {
        _togethers.addAll(togethers);
        togethers.clear();
      }
    }
    return RefreshIndicator(
        onRefresh: () async {
          _togethers.clear();
          _enabeldMorePosts = true;
          this._togetherBloc.dispatch(LoadTogetherEvent(
              dateTime: _selectedDate, lastVisibleTogether: null));
        },
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                print(_togetherBloc.currentState.toString());
                _loadMore();
              }
            },
            child: TogetherListPage(
                togethers: _togethers, isBottomLoading: isBottomLoading)));
  }

  void _loadMore() {
    if (_enabeldMorePosts == false) {
      return;
    }

    _enabeldMorePosts = false;
    if (_togethers.length > 0) {
      Together togehter = _togethers.last;
      this._togetherBloc.dispatch(LoadTogetherEvent(
          dateTime: _selectedDate, lastVisibleTogether: togehter));
      return;
    }
  }
}

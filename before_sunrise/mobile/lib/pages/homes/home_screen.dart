import 'package:before_sunrise/import.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
    @required PostBloc postBloc,
  })  : _postBloc = postBloc,
        super(key: key);

  final PostBloc _postBloc;

  @override
  HomeScreenState createState() {
    return new HomeScreenState(_postBloc);
  }
}

class HomeScreenState extends State<HomeScreen> {
  final PostBloc _postBloc;
  HomeScreenState(this._postBloc);

  PopupMenu _menu;

  int _activePageIndex = 0;
  final _pageController = PageController(initialPage: 0, keepPage: false);
  PageView _pageView;

  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _onWidgetDidBuild(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void onDismiss() {
    print('Menu is closed');
  }

  void _openCustomMenu() {
    _menu = PopupMenu(
        // backgroundColor: Theme.of(context).primaryColor,
        // lineColor: Theme.of(context).accentColor,
        maxColumn: 1,
        items: [
          MenuItem(
              title: 'Profile',
              image: Icon(
                Icons.person_outline,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Categories',
              image: Icon(
                Icons.category,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Settings',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Signout',
              image: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              )),
        ],
        onClickMenu: (result) {},
        onDismiss: onDismiss);
    // _menu.show(widgetKey: _menuButtonKey);
  }

  Container _buildPageBody(double _deviceHeight, double _deviceWidth) {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      child: Column(
        children: <Widget>[
          HomeCategoryBar(
            onActiveCategoryChange: (String categoryId) {
              print(categoryId);
            },
          ),
          SizedBox(height: 10.0),
          Flexible(child: Container()),
        ],
      ),
    );
  }

  Future<bool> _showExitAlertDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Close Application'),
            content: Text('Are you sure of exiting FASHIONet?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                  child: Text('Exit'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;
    _pageView = PageView(
      controller: _pageController,
      onPageChanged: (int index) async {
        setState(() {
          _activePageIndex = index;

          _isRefreshing = true;
        });

        if (index == 0) {
          // await _profileBloc.fetchUserProfileSubscriptions();
        }
        setState(() => _isRefreshing = false);
      },
      children: <Widget>[
        _buildPageBody(_deviceHeight, _deviceWidth),
      ],
    );

    return Consumer<PostBloc>(
          builder: (BuildContext context, PostBloc postBloc, Widget child) {
        _postBloc = postBloc;
        return RefreshIndicator(
          onRefresh: () async {},
          child: SlidingUpPanel(
            minHeight: 50.0,
            renderPanelSheet: false,
            controller: _panelController,
            body: _pageView,
            panel: Container(),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: touchedAddButton,
        tooltip: LocalizableLoader.of(context).text("hint_post"),
        child: const Icon(Icons.add),
        backgroundColor: MainTheme.enabledButtonColor,
      ),
    );
  }

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

  Future<void> touchedAddButton() async {
    // _postBloc.ready();
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(builder: (_) => PostForm()),
    // );
  }
}

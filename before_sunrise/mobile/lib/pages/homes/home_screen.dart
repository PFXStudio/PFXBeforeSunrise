import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/homes/home_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }

  // void changeActivePage(int index) {
  //   _pageController.animateToPage(index,
  //       duration: Duration(milliseconds: 500), curve: Curves.ease);
  // }
}

class HomeScreenState extends State<HomeScreen> {
  PanelController _panelController = PanelController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _activePageIndex = 0;
  final _homeBloc = new HomeBloc();

  PageView _pageView;
  Widget postPage = PostPage(
    category: "/free/posts",
  );

  final _pageController = PageController(initialPage: 0, keepPage: false);
  @override
  void initState() {
    super.initState();
    this._homeBloc.dispatch(LoadTabEvent(index: 0));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDismiss() {
    print('Menu is closed');
  }

  Container _buildPageBody(double _deviceHeight, double _deviceWidth) {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      child: Column(
        children: <Widget>[
          HomeCategoryBar(
            onActiveCategoryChange: (String categoryId) {
              setState(() {
                postPage = PostPage(category: categoryName(categoryId));
              });
              return;
            },
          ),
          SizedBox(height: 10.0),
          Flexible(child: postPage),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;
    _pageView = PageView(
      controller: _pageController,
      onPageChanged: (int index) async {},
      children: <Widget>[
        _buildPageBody(_deviceHeight, _deviceWidth),
      ],
    );
    return WillPopScope(
        onWillPop: () {
          if (_panelController.isPanelOpen()) {
            _panelController.close();
          } else {
            return _showExitAlertDialog(context);
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
          drawer: Drawer(
            child: Center(
              child: RaisedButton(
                  child: Text('Logout'),
                  onPressed: () {} // _authBloc.signout(),
                  ),
            ),
          ),
          bottomNavigationBar: HomeBottomBar(
            activeIndex: _activePageIndex,
            onActiveIndexChange: (int index) {
              _activePageIndex = index;
              _homeBloc.dispatch(LoadTabEvent(index: _activePageIndex));
            },
          ),
          body: RefreshIndicator(
              onRefresh: () async {},
              child: SlidingUpPanel(
                minHeight: 50.0,
                renderPanelSheet: false,
                controller: _panelController,
                body: BlocListener(
                    bloc: _homeBloc,
                    listener: (context, state) async {},
                    child: BlocBuilder<HomeBloc, HomeState>(
                        bloc: _homeBloc,
                        builder: (
                          BuildContext context,
                          HomeState currentState,
                        ) {
                          if (currentState is PostTabState) {
                            return _pageView;
                          }

                          if (currentState is TogetherTabState) {
                            return TogetherScreen(
                              togetherBloc: TogetherBloc(),
                            );
                          }

                          if (currentState is InfoTabState) {
                            return InfoScreen(
                              infoBloc: InfoBloc(),
                            );
                          }

                          if (currentState is ProfileTabState) {
                            return Container();
                          }
                          if (currentState is ErrorHomeState) {
                            return new Container(
                                child: new Center(
                              child: new Text('Error'),
                            ));
                          }
                          return new Container(
                              child: new Center(
                            child: new Text("В разработке"),
                          ));
                        })),
                panel: Container(),
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_homeBloc.currentState is PostTabState) {
                Navigator.pushNamed(context, PostStepForm.routeName,
                    arguments: categoryName(_activePageIndex.toString()));
                return;
              }

              if (_homeBloc.currentState is TogetherTabState) {
                Navigator.pushNamed(context, TogetherStepForm.routeName);
                return;
              }
            },
            tooltip: LocalizableLoader.of(context).text("hint_post"),
            child: const Icon(FontAwesomeIcons.plus),
            backgroundColor: MainTheme.enabledButtonColor,
          ),
        ));
  }

  Future<bool> _showExitAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Close Application'),
            content: Text('Are you sure of exiting Before Sunrise?'),
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

  String categoryName(String index) {
    if (index == "0") {
      return "/free/posts";
    }

    if (index == "1") {
      return "/realtime/posts";
    }

    return "";
  }
}

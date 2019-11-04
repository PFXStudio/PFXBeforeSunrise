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
    SuccessSnackbar().initialize(_scaffoldKey);
    FailSnackbar().initialize(_scaffoldKey);
    this._homeBloc.dispatch(LoadTabEvent(index: 0));
  }

  @override
  void dispose() {
    SuccessSnackbar().initialize(null);
    FailSnackbar().initialize(null);
    super.dispose();
  }

  void onDismiss() {
    print('Menu is closed');
  }

  Container _buildPageBody() {
    return Container(
      height: kDeviceHeight,
      width: kDeviceWidth,
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
    Profile signedProfile = ProfileBloc().signedProfile;
    var phoneNumber = signedProfile.phoneNumber;
    initializeDeviceSize(context);
    _pageView = PageView(
      controller: _pageController,
      onPageChanged: (int index) async {},
      children: <Widget>[
        _buildPageBody(),
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
      child: BlocListener(
          bloc: _homeBloc,
          listener: (context, state) async {
            if (state is UnAuthState) {
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);

              return;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
              bloc: _homeBloc,
              builder: (
                BuildContext context,
                HomeState currentState,
              ) {
                return Scaffold(
                  key: _scaffoldKey,
                  resizeToAvoidBottomInset: false,
                  appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
                  drawer: HomeDrawer(),
                  bottomNavigationBar: HomeBottomBar(
                    activeIndex: _activePageIndex,
                    onActiveIndexChange: (int index) {
                      _activePageIndex = index;
                      _homeBloc.dispatch(LoadTabEvent(index: _activePageIndex));
                    },
                  ),
                  body: SlidingUpPanel(
                    minHeight: 50.0,
                    renderPanelSheet: false,
                    controller: _panelController,
                    body: _buildContents(currentState),
                    panel: Container(),
                  ),
                  floatingActionButton:
                      _buildFloatingActionButton(currentState, phoneNumber),
                );
              })),
    );
  }

  Widget _buildContents(HomeState state) {
    if (state is PostTabState) {
      return _pageView;
    }

    if (state is TogetherTabState) {
      return TogetherScreen(
        togetherBloc: TogetherBloc(),
      );
    }

    if (state is ClubInfoTabState) {
      return ClubInfoScreen();
    }

    if (state is ProfileTabState) {
      return Container();
    }

    if (state is ErrorHomeState) {
      return new Container(
          child: new Center(
        child: new Text('Error'),
      ));
    }
    return new Container(
        child: new Center(
      child: new Text("Empty"),
    ));
  }

  Widget _buildFloatingActionButton(HomeState state, String phoneNumber) {
    print("$phoneNumber");
    if (state is ClubInfoTabState &&
        BeforeSunrise.isAdminPhoneNumber(phoneNumber) == false) {
      return Container();
    }

    return FloatingActionButton(
      onPressed: () {
        if (state is PostTabState) {
          Map<String, dynamic> infoMap = {
            "category": categoryName(_activePageIndex.toString()),
          };

          Navigator.pushNamed(context, PostStepForm.routeName,
              arguments: infoMap);
          return;
        }

        if (state is TogetherTabState) {
          Map<String, dynamic> infoMap = {};

          Navigator.pushNamed(context, TogetherStepForm.routeName,
              arguments: infoMap);
          return;
        }

        if (state is ClubInfoTabState) {
          Map<String, dynamic> infoMap = {};

          Navigator.pushNamed(context, ClubInfoStepForm.routeName,
              arguments: infoMap);
          return;
        }
      },
      tooltip: LocalizableLoader.of(context).text("hint_post"),
      child: const Icon(FontAwesomeIcons.plus),
      backgroundColor: MainTheme.enabledButtonColor,
    );
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
}

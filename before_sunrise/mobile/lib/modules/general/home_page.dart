import 'package:before_sunrise/import.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PopupMenu _menu;
  GlobalKey _menuButtonKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PanelController _panelController = PanelController();

  // CategoryBloc _categoryBloc;

  int _activePageIndex = 0;
  final _pageController = PageController(initialPage: 0, keepPage: false);
  PageView _pageView;

  ProfileBloc _profileBloc;
  PostBloc _postBloc;

  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    // initializing menu
    _openCustomMenu();

    _profileBloc = Provider.of<ProfileBloc>(context, listen: false);
    _postBloc = Provider.of<PostBloc>(context, listen: false);

    _onWidgetDidBuild(() {
      _profileBloc.fetchUserProfileSubscriptions();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _openCategoryModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Categories();
        });
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
    if (item.menuTitle == 'Profile') {
      Navigator.of(context).pushNamed('/user-profile');
    } else if (item.menuTitle == 'Categories') {
      _openCategoryModal();
    }
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
        onClickMenu: onClickMenu,
        onDismiss: onDismiss);
    // _menu.show(widgetKey: _menuButtonKey);
  }

  Widget _buildAppbarActionWidgets(
      {@required BuildContext context,
      @required int index,
      @required IconData icon}) {
    double _deviceWidth = MediaQuery.of(context).size.width;

    return InkWell(
      key: index == 1 ? _menuButtonKey : null,
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushNamed('/search');
        } else if (index == 1) {
          // _openCustomMenu();
          Rect rect = PopupMenu.getWidgetGlobalRect(_menuButtonKey);
          _menu.show(rect: rect, widgetKey: _menuButtonKey);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(
          icon,
          size: 30.0,
          color: Colors.white,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: MainTheme.appBarColor,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.white,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      title: Text(
        LocalizableLoader.of(context).text("app_title"),
        style: MainTheme.navTitleTextStyle,
      ),
      actions: <Widget>[
        _buildAppbarActionWidgets(
            context: context, index: 1, icon: Icons.more_vert),
        SizedBox(width: 10.0)
        // _buildAppBarMenuPopUp(),
      ],
    );
  }

  Container _buildPageBody(double _deviceHeight, double _deviceWidth) {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      child: Column(
        children: <Widget>[
          CategoryNavBar(
            onActiveCategoryChange: (String categoryId) {
              print(categoryId);
            },
          ),
          SizedBox(height: 10.0),
          Flexible(child: FreePost()),
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

    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    // PopupMenu.context = context;

    _pageView = PageView(
      controller: _pageController,
      onPageChanged: (int index) async {
        setState(() {
          _activePageIndex = index;

          _isRefreshing = true;
        });

        if (index == 0) {
          await _profileBloc.fetchUserProfileSubscriptions();
        }
        setState(() => _isRefreshing = false);
      },
      children: <Widget>[
        _buildPageBody(_deviceHeight, _deviceWidth),
        FeedPage(),
        LikePage(),
      ],
    );

    return WillPopScope(
      onWillPop: () {
        if (_panelController.isPanelOpen()) {
          _panelController.close();
          _menu.dismiss();
        } else {
          // _menu.dismiss();
          return _showExitAlertDialog();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        drawer: Drawer(
          child: Center(
            child: RaisedButton(
                child: Text('Logout'),
                onPressed: () {
                  // TODO : logout
                }),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          activeIndex: _activePageIndex,
          onActiveIndexChange: (int index) {
            setState(() {
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
            // setState(() => _pageController.jumpToPage(index));
          },
        ),
        body: Consumer<PostBloc>(
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
      ),
    );
  }

  Future<void> touchedAddButton() async {
    _postBloc.ready();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PostForm()),
    );
  }
}

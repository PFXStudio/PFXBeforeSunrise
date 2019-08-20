import 'package:before_sunrise/import.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
    @required HomeBloc homeBloc,
    @required PanelController panelController,
  })  : _homeBloc = homeBloc,
        _panelController = panelController,
        super(key: key);

  final HomeBloc _homeBloc;
  final PanelController _panelController;

  @override
  HomeScreenState createState() {
    return new HomeScreenState(_homeBloc);
  }

  // void changeActivePage(int index) {
  //   _pageController.animateToPage(index,
  //       duration: Duration(milliseconds: 500), curve: Curves.ease);
  // }
}

class HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc;
  HomeScreenState(this._homeBloc);

  PageView _pageView;

  final _pageController = PageController(initialPage: 0, keepPage: false);
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
          Flexible(child: FreePostPage()),
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
    return BlocListener(
        bloc: widget._homeBloc,
        listener: (context, state) async {},
        child: BlocBuilder<HomeBloc, HomeState>(
            bloc: widget._homeBloc,
            builder: (
              BuildContext context,
              HomeState currentState,
            ) {
              if (currentState is PostTabState) {
                return RefreshIndicator(
                  onRefresh: () async {},
                  child: SlidingUpPanel(
                    minHeight: 50.0,
                    renderPanelSheet: false,
                    controller: widget._panelController,
                    body: _pageView,
                    panel: Container(),
                  ),
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
            }));
  }
}

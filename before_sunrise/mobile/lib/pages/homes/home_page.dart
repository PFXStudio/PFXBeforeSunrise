import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/homes/home_app_bar.dart';
import 'package:before_sunrise/pages/homes/home_bottom_bar.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home";
  final PanelController _panelController = PanelController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _activePageIndex = 0;
  var _homeBloc = new HomeBloc();

  @override
  Widget build(BuildContext context) {
    final HomeScreen _homeScreen = HomeScreen(
      panelController: _panelController,
      homeBloc: _homeBloc,
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
              _homeBloc.dispatch(LoadTabEvent(index: _activePageIndex));
            },
          ),
          body: _homeScreen,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, PostFormPage.routeName);
            },
            tooltip: LocalizableLoader.of(context).text("hint_post"),
            child: const Icon(Icons.add),
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
}

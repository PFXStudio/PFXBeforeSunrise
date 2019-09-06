import 'package:before_sunrise/import.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBar({Key key, this.scaffoldKey})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
  final GlobalKey<ScaffoldState> scaffoldKey;
}

class _HomeAppBarState extends State<HomeAppBar> {
  final GlobalKey _menuButtonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: MainTheme.appBarColor,
      leading: IconButton(
        icon: Icon(
          FontAwesomeIcons.bars,
          size: 25.0,
          color: Colors.white,
        ),
        onPressed: () => widget.scaffoldKey.currentState.openDrawer(),
      ),
      title: Text(
        LocalizableLoader.of(context).text("app_title"),
        style: MainTheme.navTitleTextStyle,
      ),
      actions: <Widget>[
        _buildAppbarActionWidgets(
            context: context, index: 1, icon: FontAwesomeIcons.ellipsisV),
        SizedBox(width: 10.0)
        // _buildAppBarMenuPopUp(),
      ],
    );
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
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(
          icon,
          size: 25.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void onDismiss() {
    print('Menu is closed');
  }
}

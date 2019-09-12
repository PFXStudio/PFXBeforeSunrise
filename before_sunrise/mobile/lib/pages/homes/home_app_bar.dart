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
    final List<String> menus = [
      "1111",
      "1122",
      "1133",
    ];

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
        SizedBox(width: 10.0),
        PopupMenuButton<String>(
          icon: Icon(FontAwesomeIcons.ellipsisV),
          onSelected: _selectedMenu,
          itemBuilder: (BuildContext context) {
            return menus.map((String choice) {
              return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.accessibleIcon),
                      SizedBox(
                        width: 5,
                      ),
                      Text(choice),
                    ],
                  ));
            }).toList();
          },
        )
      ],
    );
  }

  Widget _buildAppbarActionWidgets(
      {@required BuildContext context,
      @required int index,
      @required IconData icon}) {
    return InkWell(
      key: index == 1 ? _menuButtonKey : null,
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushNamed('/search');
        } else if (index == 1) {}
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

  void _selectedMenu(index) {}

  void onDismiss() {
    print('Menu is closed');
  }
}

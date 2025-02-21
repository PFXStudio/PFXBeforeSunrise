import 'package:before_sunrise/import.dart';

class ProfileBottomBar extends StatefulWidget {
  final int activeIndex;
  final Function(int) onActiveIndexChange;
  final bool isCurrentUserProfile;

  const ProfileBottomBar(
      {Key key,
      this.activeIndex = 0,
      @required this.onActiveIndexChange,
      this.isCurrentUserProfile = false})
      : super(key: key);

  @override
  _ProfileBottomBarState createState() => _ProfileBottomBarState();
}

class _ProfileBottomBarState extends State<ProfileBottomBar> {
  int _activeIndex;
  Function(int) get _onActiveIndexChanged => widget.onActiveIndexChange;
  bool get _isCurrentUserProfile => widget.isCurrentUserProfile;

  @override
  void initState() {
    _activeIndex = widget.activeIndex;
    super.initState();
  }

  double get _deviceWidth => kDeviceWidth;

  // Color get _accentColor => Theme.of(context).accentColor;
  Color get _primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Container(
        height: 60.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0.0,
              child: Container(
                width: _deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildBottomNavBarItem(
                        index: 0, icon: FontAwesomeIcons.quoteLeft),
                    !_isCurrentUserProfile
                        ? Container()
                        : _buildBottomNavBarItem(
                            index: 1,
                            icon: Icons.subscriptions,
                          ),
                    _buildBottomNavBarItem(
                      index: !_isCurrentUserProfile ? 1 : 2,
                      icon: FontAwesomeIcons.idCard,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getItemSize({@required int index}) {
    return index == _activeIndex ? 28.0 : 22.0;
  }

  Color _getItemColor({@required int index}) {
    return index == _activeIndex ? _primaryColor : Colors.grey[300];
  }

  Widget _buildBottomNavBarItem(
      {@required int index, @required IconData icon}) {
    final double itemWidth = _deviceWidth / 5;

    return Container(
      width: itemWidth,
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(
              icon,
              size: _getItemSize(index: index),
              color: _getItemColor(index: index),
            ),
            onPressed: () {
              if (_activeIndex != index) {
                setState(() {
                  _activeIndex = index;
                  _onActiveIndexChanged(index);
                });
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 7.0),
              Visibility(
                visible: index == _activeIndex,
                child: Container(
                  height: 5.0,
                  width: itemWidth / 4,
                  margin: EdgeInsets.only(bottom: 5.0),
                  decoration: BoxDecoration(
                      color: MainTheme.pivotColor,
                      // color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

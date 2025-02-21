import 'package:before_sunrise/import.dart';

class BottomNavBar extends StatefulWidget {
  final int activeIndex;
  final Function(int) onActiveIndexChange;

  const BottomNavBar(
      {Key key, this.activeIndex, @required this.onActiveIndexChange})
      : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _activeIndex;
  Function(int) get _onActiveIndexChanged => widget.onActiveIndexChange;

  @override
  void initState() {
    _activeIndex = widget.activeIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    _activeIndex = widget.activeIndex;
    super.didUpdateWidget(oldWidget);
  }

  double get _deviceWidth => kDeviceWidth;
  Color get _accentColor => MainTheme.pivotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0.0,
            child: BottomAppBar(
              // shape: CircularNotchedRectangle(),
              child: Container(
                width: _deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildBottomNavBarItem(
                      index: 0,
                      icon: FontAwesomeIcons.hubspot,
                    ),
                    _buildBottomNavBarItem(
                      index: 1,
                      icon: FontAwesomeIcons.calendarDay,
                    ),
                    _buildBottomNavBarItem(
                      index: 2,
                      icon: FontAwesomeIcons.comment,
                    ),
                    // Container(
                    //   width: _deviceWidth / 6,
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getItemSize({@required int index}) {
    return index == _activeIndex ? 40.0 : 35.0;
  }

  Color _getItemColor({@required int index}) {
    return index == _activeIndex
        ? MainTheme.enabledButtonColor
        : MainTheme.disabledButtonColor;
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
                      color: _accentColor,
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

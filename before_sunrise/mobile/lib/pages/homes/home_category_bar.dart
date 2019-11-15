import 'package:before_sunrise/import.dart';

class HomeCategoryBar extends StatefulWidget {
  final Function(String) onActiveCategoryChange;

  const HomeCategoryBar({Key key, @required this.onActiveCategoryChange})
      : super(key: key);

  @override
  _HomeCategoryBarState createState() => _HomeCategoryBarState();
}

class _HomeCategoryBarState extends State<HomeCategoryBar> {
  String _activeCategoryId;

  @override
  void initState() {
    _activeCategoryId = '0';
    super.initState();
  }

  List<String> _categories;

  Function(String) get _onActiveCategoryChange => widget.onActiveCategoryChange;

  @override
  Widget build(BuildContext context) {
    _categories = <String>[
      LocalizableLoader.of(context).text("${PostType.free}"),
      LocalizableLoader.of(context).text("${PostType.realTime}"),
      LocalizableLoader.of(context).text("${PostType.together}"),
      LocalizableLoader.of(context).text("${PostType.gallery}"),
      LocalizableLoader.of(context).text("${PostType.maxLastest}"),
    ];

    return Container(
      height: 43.0,
      width: double.infinity,
      child: ListView.builder(
        itemCount: _categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final String categoryTitle = _categories[index];

          return _buildCategoryItem(
              categoryIndex: index,
              categoryId: index.toString(),
              categoryTitle: categoryTitle);
        },
      ),
    );
  }

  double _getItemSize({@required String categoryId}) {
    return categoryId == _activeCategoryId ? 22.0 : 20.0;
  }

  Color _getItemColor({@required String categoryId}) {
    return categoryId == _activeCategoryId
        ? MainTheme.enabledButtonColor
        : Colors.grey[300];
  }

  Widget _buildCategoryItem(
      {@required int categoryIndex,
      @required String categoryId,
      @required String categoryTitle}) {
    double _deviceWidth = kDeviceWidth;
    double _spacerWidth =
        _deviceWidth / (double.parse((_categories.length * 2).toString()));

    return Row(
      children: <Widget>[
        categoryIndex == 0 ? SizedBox(width: 20.0) : Container(),
        InkWell(
          onTap: () {
            if (_activeCategoryId != categoryId) {
              setState(() {
                _activeCategoryId = categoryId;
                _onActiveCategoryChange(categoryId);
              });
            }
          },
          child: Column(
            children: <Widget>[
              Text(
                '$categoryTitle',
                style: TextStyle(
                    color: _getItemColor(categoryId: categoryId),
                    fontSize: _getItemSize(categoryId: categoryId),
                    fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: _activeCategoryId == categoryId,
                child: Container(
                  height: 5.0,
                  width: _spacerWidth,
                  margin: EdgeInsets.only(bottom: 5.0),
                  decoration: BoxDecoration(
                      color: MainTheme.pivotColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      )),
                ),
              )
            ],
          ),
        ),
        SizedBox(width: _spacerWidth)
      ],
    );
  }
}

import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart' as intl;

class CocktailCountInfo {
  CocktailCountInfo({this.hardCount, this.champagneCount, this.serviceCount});
  double hardCount = 0;
  double champagneCount = 0;
  double serviceCount = 0;
}

CocktailCountInfo s_cocktailCountInfo =
    CocktailCountInfo(hardCount: 0, champagneCount: 0, serviceCount: 0);
typedef TogetherFormCocktailCountCallback = void Function(
    CocktailCountInfo editCocktailCountInfo);

class TogetherFormCocktailCount extends StatefulWidget {
  TogetherFormCocktailCount({
    this.callback,
    this.editCocktailCountInfo,
  });
  @override
  _TogetherFormCocktailCountState createState() {
    if (editCocktailCountInfo == null) {
      return _TogetherFormCocktailCountState();
    }

    s_cocktailCountInfo.hardCount = editCocktailCountInfo.hardCount;
    s_cocktailCountInfo.champagneCount = editCocktailCountInfo.champagneCount;
    s_cocktailCountInfo.serviceCount = editCocktailCountInfo.serviceCount;
    return _TogetherFormCocktailCountState();
  }

  final TogetherFormCocktailCountCallback callback;
  final CocktailCountInfo editCocktailCountInfo;
}

class _TogetherFormCocktailCountState extends State<TogetherFormCocktailCount> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    s_cocktailCountInfo.hardCount = 0;
    s_cocktailCountInfo.champagneCount = 0;
    s_cocktailCountInfo.serviceCount = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(s_cocktailCountInfo.hardCount.toInt());
    print(s_cocktailCountInfo.champagneCount.toInt());
    print(s_cocktailCountInfo.serviceCount.toInt());
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.cocktail,
        color: MainTheme.enabledButtonColor,
        text: s_cocktailCountInfo.hardCount != 0 ||
                s_cocktailCountInfo.champagneCount != 0
            ? "${s_cocktailCountInfo.hardCount.toInt()}하드, ${s_cocktailCountInfo.champagneCount.toInt()}샴, ${s_cocktailCountInfo.serviceCount.toInt()}서비스"
            : LocalizableLoader.of(context).text("cocktail_count_select"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        DialogHeaderWidget(
                            title: LocalizableLoader.of(context)
                                .text("cocktail_count_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: TogetherFormCocktailCountContentsWidget(),
                        ),
                        DialogBottomWidget(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            Navigator.pop(context);
                            if (widget.callback == null) {
                              return;
                            }

                            widget.callback(s_cocktailCountInfo);
                            setState(() {});
                          },
                        )
                      ])));
        });
  }
}

class TogetherFormCocktailCountContentsWidget extends StatefulWidget {
  @override
  _TogetherFormCocktailCountContentsWidgetState createState() =>
      _TogetherFormCocktailCountContentsWidgetState();
}

class _TogetherFormCocktailCountContentsWidgetState
    extends State<TogetherFormCocktailCountContentsWidget> {
  @override
  final double maxCount = 30;

  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: IconButton(
                    padding: EdgeInsets.only(top: 28),
                    icon: Icon(FontAwesomeIcons.caretLeft),
                    color: Colors.blueAccent,
                    onPressed: () {
                      setState(() {
                        if (s_cocktailCountInfo.hardCount > 0) {
                          s_cocktailCountInfo.hardCount =
                              s_cocktailCountInfo.hardCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_cocktailCountInfo.hardCount],
                      rangeSlider: false,
                      max: maxCount,
                      min: 0,
                      step: 1,
                      jump: true,
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBarHeight: 2,
                        activeTrackBarHeight: 3,
                      ),
                      disabled: false,
                      handler: customHandler(FontAwesomeIcons.caretRight),
                      rightHandler: customHandler(FontAwesomeIcons.caretLeft),
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: true,
                        numberFormat: intl.NumberFormat(),
                        rightSuffix: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                LocalizableLoader.of(context)
                                    .text("hard_bottle"),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                        textStyle:
                            TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          s_cocktailCountInfo.hardCount = lowerValue;
                        });
                      },
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      padding: EdgeInsets.only(top: 28),
                      icon: Icon(FontAwesomeIcons.caretRight),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          if (s_cocktailCountInfo.hardCount < maxCount) {
                            s_cocktailCountInfo.hardCount =
                                s_cocktailCountInfo.hardCount + 1;
                          }
                        });
                      },
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: IconButton(
                    padding: EdgeInsets.only(top: 28),
                    icon: Icon(FontAwesomeIcons.caretLeft),
                    color: Colors.blueAccent,
                    onPressed: () {
                      setState(() {
                        if (s_cocktailCountInfo.champagneCount > 0) {
                          s_cocktailCountInfo.champagneCount =
                              s_cocktailCountInfo.champagneCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_cocktailCountInfo.champagneCount],
                      rangeSlider: false,
                      max: maxCount,
                      min: 0,
                      step: 1,
                      jump: true,
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBarHeight: 2,
                        activeTrackBarHeight: 3,
                      ),
                      disabled: false,
                      handler: customHandler(FontAwesomeIcons.caretRight),
                      rightHandler: customHandler(FontAwesomeIcons.caretLeft),
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: true,
                        numberFormat: intl.NumberFormat(),
                        rightSuffix: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                LocalizableLoader.of(context)
                                    .text("champagne_bottle"),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                        textStyle:
                            TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          s_cocktailCountInfo.champagneCount = lowerValue;
                        });
                      },
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      padding: EdgeInsets.only(top: 28),
                      icon: Icon(FontAwesomeIcons.caretRight),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          if (s_cocktailCountInfo.champagneCount < maxCount) {
                            s_cocktailCountInfo.champagneCount =
                                s_cocktailCountInfo.champagneCount + 1;
                          }
                        });
                      },
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: IconButton(
                    padding: EdgeInsets.only(top: 28),
                    icon: Icon(FontAwesomeIcons.caretLeft),
                    color: Colors.blueAccent,
                    onPressed: () {
                      setState(() {
                        if (s_cocktailCountInfo.serviceCount > 0) {
                          s_cocktailCountInfo.serviceCount =
                              s_cocktailCountInfo.serviceCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_cocktailCountInfo.serviceCount],
                      rangeSlider: false,
                      max: maxCount,
                      min: 0,
                      step: 1,
                      jump: true,
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBarHeight: 2,
                        activeTrackBarHeight: 3,
                      ),
                      disabled: false,
                      handler: customHandler(FontAwesomeIcons.caretRight),
                      rightHandler: customHandler(FontAwesomeIcons.caretLeft),
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: true,
                        numberFormat: intl.NumberFormat(),
                        rightSuffix: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                LocalizableLoader.of(context)
                                    .text("service_bottle"),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                        textStyle:
                            TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          s_cocktailCountInfo.serviceCount = lowerValue;
                        });
                      },
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      padding: EdgeInsets.only(top: 28),
                      icon: Icon(FontAwesomeIcons.caretRight),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          if (s_cocktailCountInfo.serviceCount < maxCount) {
                            s_cocktailCountInfo.serviceCount =
                                s_cocktailCountInfo.serviceCount + 1;
                          }
                        });
                      },
                    )),
              ],
            ),
          ],
        ));
  }

  customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 0.05,
                blurRadius: 5,
                offset: Offset(0, 1))
          ],
        ),
      ),
    );
  }
}

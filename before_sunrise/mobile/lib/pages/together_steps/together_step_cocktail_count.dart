import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart' as intl;

class CocktailCountInfo {
  CocktailCountInfo({this.hardCount, this.champagneCount, this.serviceCount});
  double hardCount = 0;
  double champagneCount = 0;
  double serviceCount = 0;
}

CocktailCountInfo cocktailCountInfo =
    CocktailCountInfo(hardCount: 0, champagneCount: 0, serviceCount: 0);
typedef TogetherStepCocktailCountCallback = void Function(
    CocktailCountInfo editCocktailCountInfo);

class TogetherStepCocktailCount extends StatefulWidget {
  TogetherStepCocktailCount({
    this.callback,
    this.editCocktailCountInfo,
  });
  @override
  _TogetherStepCocktailCountState createState() {
    if (editCocktailCountInfo == null) {
      return _TogetherStepCocktailCountState();
    }

    cocktailCountInfo.hardCount = editCocktailCountInfo.hardCount;
    cocktailCountInfo.champagneCount = editCocktailCountInfo.champagneCount;
    cocktailCountInfo.serviceCount = editCocktailCountInfo.serviceCount;
    return _TogetherStepCocktailCountState();
  }

  final TogetherStepCocktailCountCallback callback;
  final CocktailCountInfo editCocktailCountInfo;
}

class _TogetherStepCocktailCountState extends State<TogetherStepCocktailCount> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cocktailCountInfo.hardCount = 0;
    cocktailCountInfo.champagneCount = 0;
    cocktailCountInfo.serviceCount = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(cocktailCountInfo.hardCount.toInt());
    print(cocktailCountInfo.champagneCount.toInt());
    print(cocktailCountInfo.serviceCount.toInt());
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.cocktail,
        color: MainTheme.enabledButtonColor,
        text: cocktailCountInfo.hardCount != 0 ||
                cocktailCountInfo.champagneCount != 0
            ? "${cocktailCountInfo.hardCount.toInt()}하드, ${cocktailCountInfo.champagneCount.toInt()}샴, ${cocktailCountInfo.serviceCount.toInt()}서비스"
            : LocalizableLoader.of(context).text("cocktail_count_select_hint"),
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
                        HeaderDialog(
                            title: LocalizableLoader.of(context)
                                .text("cocktail_count_select_hint")),
                        Material(
                          type: MaterialType.transparency,
                          child: TogetherStepCocktailCountContentsWidget(),
                        ),
                        BottomDialog(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            Navigator.pop(context);
                            if (widget.callback == null) {
                              return;
                            }

                            widget.callback(cocktailCountInfo);
                            setState(() {});
                          },
                        )
                      ])));
        });
  }
}

class TogetherStepCocktailCountContentsWidget extends StatefulWidget {
  @override
  _TogetherStepCocktailCountContentsWidgetState createState() =>
      _TogetherStepCocktailCountContentsWidgetState();
}

class _TogetherStepCocktailCountContentsWidgetState
    extends State<TogetherStepCocktailCountContentsWidget> {
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
                        if (cocktailCountInfo.hardCount > 0) {
                          cocktailCountInfo.hardCount =
                              cocktailCountInfo.hardCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [cocktailCountInfo.hardCount],
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
                          cocktailCountInfo.hardCount = lowerValue;
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
                          if (cocktailCountInfo.hardCount < maxCount) {
                            cocktailCountInfo.hardCount =
                                cocktailCountInfo.hardCount + 1;
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
                        if (cocktailCountInfo.champagneCount > 0) {
                          cocktailCountInfo.champagneCount =
                              cocktailCountInfo.champagneCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [cocktailCountInfo.champagneCount],
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
                          cocktailCountInfo.champagneCount = lowerValue;
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
                          if (cocktailCountInfo.champagneCount < maxCount) {
                            cocktailCountInfo.champagneCount =
                                cocktailCountInfo.champagneCount + 1;
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
                        if (cocktailCountInfo.serviceCount > 0) {
                          cocktailCountInfo.serviceCount =
                              cocktailCountInfo.serviceCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [cocktailCountInfo.serviceCount],
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
                          cocktailCountInfo.serviceCount = lowerValue;
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
                          if (cocktailCountInfo.serviceCount < maxCount) {
                            cocktailCountInfo.serviceCount =
                                cocktailCountInfo.serviceCount + 1;
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

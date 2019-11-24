import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart' as intl;

class ClubPriceInfo {
  ClubPriceInfo({this.entrance, this.table});
  double entrance = 0;
  double table = 0;
}

ClubPriceInfo s_clubPriceInfo = ClubPriceInfo(entrance: 0, table: 0);
typedef DialogClubPriceCallback = void Function(ClubPriceInfo priceInfo);

class DialogClubPrice extends StatefulWidget {
  DialogClubPrice({this.callback = null, this.editPriceInfo});
  @override
  _DialogClubPriceState createState() {
    if (editPriceInfo == null) {
      return _DialogClubPriceState();
    }

    s_clubPriceInfo.entrance = editPriceInfo.entrance;
    s_clubPriceInfo.table = editPriceInfo.table;
    return _DialogClubPriceState();
  }

  DialogClubPriceCallback callback;
  ClubPriceInfo editPriceInfo;
}

class _DialogClubPriceState extends State<DialogClubPrice> {
  @override
  void dispose() {
    s_clubPriceInfo.entrance = 0;
    s_clubPriceInfo.table = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatIconTextButton(
            iconData: FontAwesomeIcons.wonSign,
            color: MainTheme.enabledButtonColor,
            text: s_clubPriceInfo.entrance != 0
                ? "${s_clubPriceInfo.entrance.toInt()}만원"
                : LocalizableLoader.of(context).text("price_select"),
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
                                    .text("price_select")),
                            Material(
                              type: MaterialType.transparency,
                              child: DialogClubPriceContentsWidget(),
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

                                widget.callback(s_clubPriceInfo);
                                setState(() {});
                              },
                            )
                          ])));
            }),
        FlatIconTextButton(
            iconData: FontAwesomeIcons.wonSign,
            color: MainTheme.enabledButtonColor,
            text: s_clubPriceInfo.entrance != 0
                ? "${s_clubPriceInfo.entrance.toInt()}만원"
                : LocalizableLoader.of(context).text("price_select"),
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
                                    .text("price_select")),
                            Material(
                              type: MaterialType.transparency,
                              child: DialogClubPriceContentsWidget(),
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

                                widget.callback(s_clubPriceInfo);
                                setState(() {});
                              },
                            )
                          ])));
            })
      ],
    );
  }
}

priceHandler(IconData icon) {
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
          size: 14,
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

class DialogClubPriceContentsWidget extends StatefulWidget {
  @override
  _DialogClubPriceContentsWidgetState createState() =>
      _DialogClubPriceContentsWidgetState();
}

class _DialogClubPriceContentsWidgetState
    extends State<DialogClubPriceContentsWidget> {
  @override
  final double maxPrice = 1000;
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
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          if (s_clubPriceInfo.entrance > 10) {
                            s_clubPriceInfo.entrance =
                                s_clubPriceInfo.entrance - 1;
                          }
                        });
                      },
                    )),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_clubPriceInfo.entrance],
                      rangeSlider: false,
                      max: maxPrice,
                      min: 0,
                      step: 1,
                      jump: true,
                      trackBar: FlutterSliderTrackBar(
                        activeDisabledTrackBarColor: Colors.red,
                        inactiveTrackBarHeight: 2,
                        activeTrackBarHeight: 3,
                      ),
                      disabled: false,
                      handler: priceHandler(FontAwesomeIcons.circle),
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: true,
                        numberFormat: intl.NumberFormat(),
                        // leftPrefix: Icon(
                        //   FontAwesomeIcons.wonSign,
                        //   size: 14,
                        //   color: Colors.black45,
                        // ),
                        rightSuffix: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                LocalizableLoader.of(context).text("manwon"),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          s_clubPriceInfo.entrance = lowerValue;
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
                          if (s_clubPriceInfo.entrance < maxPrice) {
                            s_clubPriceInfo.entrance =
                                s_clubPriceInfo.entrance + 1;
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
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          if (s_clubPriceInfo.table > 0) {
                            s_clubPriceInfo.table = s_clubPriceInfo.table - 1;
                          }
                        });
                      },
                    )),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_clubPriceInfo.table],
                      rangeSlider: false,
                      max: 10,
                      min: 0,
                      step: 1,
                      jump: true,
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBarHeight: 2,
                        activeTrackBarHeight: 3,
                      ),
                      disabled: false,
                      handler: priceHandler(FontAwesomeIcons.circle),
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: true,
                        numberFormat: intl.NumberFormat(),
                        // leftPrefix: Icon(
                        //   FontAwesomeIcons.wonSign,
                        //   size: 14,
                        //   color: Colors.black45,
                        // ),
                        rightSuffix: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                LocalizableLoader.of(context).text("manwon"),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          s_clubPriceInfo.table = lowerValue;
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
                          if (s_clubPriceInfo.table < maxPrice) {
                            s_clubPriceInfo.table = s_clubPriceInfo.table + 1;
                          }
                        });
                      },
                    )),
              ],
            )
          ],
        ));
  }
}

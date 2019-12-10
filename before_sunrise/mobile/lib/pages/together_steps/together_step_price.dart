import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart' as intl;

class PriceInfo {
  PriceInfo({this.tablePrice, this.tipPrice});
  double tablePrice = 0;
  double tipPrice = 0;
}

PriceInfo s_priceInfo = PriceInfo(tablePrice: 0, tipPrice: 0);
typedef TogetherStepPriceCallback = void Function(PriceInfo priceInfo);

class TogetherStepPrice extends StatefulWidget {
  TogetherStepPrice({this.callback = null, this.editPriceInfo});
  @override
  _TogetherStepPriceState createState() {
    if (editPriceInfo == null) {
      return _TogetherStepPriceState();
    }

    s_priceInfo.tablePrice = editPriceInfo.tablePrice;
    s_priceInfo.tipPrice = editPriceInfo.tipPrice;
    return _TogetherStepPriceState();
  }

  TogetherStepPriceCallback callback;
  PriceInfo editPriceInfo;
}

class _TogetherStepPriceState extends State<TogetherStepPrice> {
  @override
  void dispose() {
    s_priceInfo.tablePrice = 0;
    s_priceInfo.tipPrice = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.wonSign,
        color: MainTheme.enabledButtonColor,
        text: s_priceInfo.tablePrice != 0
            ? "${s_priceInfo.tablePrice.toInt()} + ${s_priceInfo.tipPrice.toInt()} = ${s_priceInfo.tablePrice.toInt() + s_priceInfo.tipPrice.toInt()}만원"
            : LocalizableLoader.of(context).text("price_select_hint"),
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
                                .text("price_select_hint")),
                        Material(
                          type: MaterialType.transparency,
                          child: TogetherStepPriceContentsWidget(),
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

                            widget.callback(s_priceInfo);
                            setState(() {});
                          },
                        )
                      ])));
        });
  }
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

class TogetherStepPriceContentsWidget extends StatefulWidget {
  @override
  _TogetherStepPriceContentsWidgetState createState() =>
      _TogetherStepPriceContentsWidgetState();
}

class _TogetherStepPriceContentsWidgetState
    extends State<TogetherStepPriceContentsWidget> {
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
                          if (s_priceInfo.tablePrice > 10) {
                            s_priceInfo.tablePrice = s_priceInfo.tablePrice - 1;
                          }
                        });
                      },
                    )),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_priceInfo.tablePrice],
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
                      handler: customHandler(FontAwesomeIcons.circle),
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
                          s_priceInfo.tablePrice = lowerValue;
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
                          if (s_priceInfo.tablePrice < maxPrice) {
                            s_priceInfo.tablePrice = s_priceInfo.tablePrice + 1;
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
                          if (s_priceInfo.tipPrice > 0) {
                            s_priceInfo.tipPrice = s_priceInfo.tipPrice - 1;
                          }
                        });
                      },
                    )),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_priceInfo.tipPrice],
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
                      handler: customHandler(FontAwesomeIcons.circle),
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
                          s_priceInfo.tipPrice = lowerValue;
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
                          if (s_priceInfo.tipPrice < maxPrice) {
                            s_priceInfo.tipPrice = s_priceInfo.tipPrice + 1;
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

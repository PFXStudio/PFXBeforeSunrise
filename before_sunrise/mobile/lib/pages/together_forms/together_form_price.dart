import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart' as intl;

double togetherPrice = 0;
typedef TogetherFormPriceCallback = void Function(int price);

class TogetherFormPrice extends StatefulWidget {
  TogetherFormPrice({this.callback = null});
  @override
  _TogetherFormPriceState createState() => _TogetherFormPriceState();
  TogetherFormPriceCallback callback;
}

class TogetherFormPriceContentsWidget extends StatefulWidget {
  @override
  _TogetherFormPriceContentsWidgetState createState() =>
      _TogetherFormPriceContentsWidgetState();
}

class _TogetherFormPriceContentsWidgetState
    extends State<TogetherFormPriceContentsWidget> {
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
                          if (togetherPrice > 10) {
                            togetherPrice = togetherPrice - 1;
                          }
                        });
                      },
                    )),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [togetherPrice],
                      rangeSlider: false,
                      max: maxPrice,
                      min: 0,
                      step: 1,
                      jump: true,
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBarHeight: 2,
                        activeTrackBarHeight: 3,
                      ),
                      disabled: false,
                      handler: customHandler(Icons.chevron_right),
                      rightHandler: customHandler(Icons.chevron_left),
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
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          togetherPrice = lowerValue;
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
                          if (togetherPrice < maxPrice) {
                            togetherPrice = togetherPrice + 1;
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

class _TogetherFormPriceState extends State<TogetherFormPrice> {
  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.wonSign,
        color: MainTheme.enabledButtonColor,
        width: 170,
        text: togetherPrice != 0
            ? "${togetherPrice.toInt()} 만원"
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
                          child: TogetherFormPriceContentsWidget(),
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

                            widget.callback(togetherPrice.toInt());
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

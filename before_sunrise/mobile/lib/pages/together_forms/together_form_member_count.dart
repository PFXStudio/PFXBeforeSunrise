import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart' as intl;

double togetherTotalCount = 2;
double togetherRestCount = 1;
typedef TogetherFormMemberCountCallback = void Function(
    int totalCount, int restCount);

class TogetherFormMemberCount extends StatefulWidget {
  TogetherFormMemberCount({this.callback});
  @override
  _TogetherFormMemberCountState createState() =>
      _TogetherFormMemberCountState();
  final TogetherFormMemberCountCallback callback;
}

class _TogetherFormMemberCountState extends State<TogetherFormMemberCount> {
  double selectedPrice = 0;
  @override
  void dispose() {
    togetherTotalCount = 2;
    togetherRestCount = 1;
    super.dispose();
  }

  Widget _buildContents(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Container(
            margin: EdgeInsets.only(top: 50),
            alignment: Alignment.centerLeft,
            child: Container()));
  }

  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.users,
        color: MainTheme.enabledButtonColor,
        text: togetherTotalCount > 2
            ? "총 인원 : ${togetherTotalCount.toInt()}, 모집 인원 : ${togetherRestCount.toInt()}"
            : LocalizableLoader.of(context).text("member_count_select"),
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
                                .text("member_count_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: TogetherFormMemberCountContentsWidget(),
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

                            widget.callback(togetherTotalCount.toInt(),
                                togetherRestCount.toInt());
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

class TogetherFormMemberCountContentsWidget extends StatefulWidget {
  @override
  _TogetherFormMemberCountContentsWidgetState createState() =>
      _TogetherFormMemberCountContentsWidgetState();
}

class _TogetherFormMemberCountContentsWidgetState
    extends State<TogetherFormMemberCountContentsWidget> {
  final double maxCount = 15;

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
                        if (togetherTotalCount > 2) {
                          togetherTotalCount = togetherTotalCount - 1;
                          if (togetherRestCount > togetherTotalCount) {
                            togetherRestCount = togetherTotalCount;
                          }
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [togetherTotalCount],
                      rangeSlider: false,
                      max: maxCount,
                      min: 2,
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
                                    .text("total_member_count"),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                        textStyle:
                            TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          togetherTotalCount = lowerValue;
                          if (togetherRestCount > togetherTotalCount) {
                            togetherRestCount = togetherTotalCount;
                          }
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
                          if (togetherTotalCount < maxCount) {
                            togetherTotalCount = togetherTotalCount + 1;
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
                        if (togetherRestCount > 1) {
                          togetherRestCount = togetherRestCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [togetherRestCount],
                      rangeSlider: false,
                      max: togetherTotalCount,
                      min: 1,
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
                                    .text("rest_member_count"),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                        textStyle:
                            TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          togetherRestCount = lowerValue;
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
                          if (togetherRestCount < togetherTotalCount) {
                            togetherRestCount = togetherRestCount + 1;
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

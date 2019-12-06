import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart' as intl;

class MemberCountInfo {
  MemberCountInfo({this.totalCount, this.restCount});
  double totalCount = 2;
  double restCount = 1;
}

MemberCountInfo s_memberCountInfo =
    MemberCountInfo(totalCount: 2, restCount: 1);
typedef TogetherFormMemberCountCallback = void Function(
    MemberCountInfo memberCountInfo);

class TogetherFormMemberCount extends StatefulWidget {
  TogetherFormMemberCount({this.callback, this.editMemberCountInfo});
  @override
  _TogetherFormMemberCountState createState() {
    if (editMemberCountInfo == null) {
      return _TogetherFormMemberCountState();
    }

    s_memberCountInfo.totalCount = editMemberCountInfo.totalCount;
    s_memberCountInfo.restCount = editMemberCountInfo.restCount;
    return _TogetherFormMemberCountState();
  }

  final TogetherFormMemberCountCallback callback;
  final MemberCountInfo editMemberCountInfo;
}

class _TogetherFormMemberCountState extends State<TogetherFormMemberCount> {
  double selectedPrice = 0;
  @override
  void dispose() {
    s_memberCountInfo.totalCount = 2;
    s_memberCountInfo.restCount = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.users,
        color: MainTheme.enabledButtonColor,
        text: s_memberCountInfo.totalCount > 2
            ? "총 인원 : ${s_memberCountInfo.totalCount.toInt()}, 모집 인원 : ${s_memberCountInfo.restCount.toInt()}"
            : LocalizableLoader.of(context).text("member_count_select_hint"),
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
                                .text("member_count_select_hint")),
                        Material(
                          type: MaterialType.transparency,
                          child: TogetherFormMemberCountContentsWidget(),
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

                            widget.callback(s_memberCountInfo);
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
                        if (s_memberCountInfo.totalCount > 2) {
                          s_memberCountInfo.totalCount =
                              s_memberCountInfo.totalCount - 1;
                          if (s_memberCountInfo.restCount >
                              s_memberCountInfo.totalCount) {
                            s_memberCountInfo.restCount =
                                s_memberCountInfo.totalCount;
                          }
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_memberCountInfo.totalCount],
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
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          s_memberCountInfo.totalCount = lowerValue;
                          if (s_memberCountInfo.restCount >
                              s_memberCountInfo.totalCount) {
                            s_memberCountInfo.restCount =
                                s_memberCountInfo.totalCount;
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
                          if (s_memberCountInfo.totalCount < maxCount) {
                            s_memberCountInfo.totalCount =
                                s_memberCountInfo.totalCount + 1;
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
                        if (s_memberCountInfo.restCount > 1) {
                          s_memberCountInfo.restCount =
                              s_memberCountInfo.restCount - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: FlutterSlider(
                      values: [s_memberCountInfo.restCount],
                      rangeSlider: false,
                      max: s_memberCountInfo.totalCount,
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
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          s_memberCountInfo.restCount = lowerValue;
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
                          if (s_memberCountInfo.restCount <
                              s_memberCountInfo.totalCount) {
                            s_memberCountInfo.restCount =
                                s_memberCountInfo.restCount + 1;
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

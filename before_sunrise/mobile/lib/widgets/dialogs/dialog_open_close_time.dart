import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

typedef DialogOpenCloseTimeCallback = void Function(String time);

DateTime dialogOpenDateTime;
DateTime dialogCloseDateTime;

class DialogOpenCloseTime extends StatefulWidget {
  DialogOpenCloseTime({@required this.callback, @required this.title});
  @override
  _DialogOpenCloseTimeState createState() => _DialogOpenCloseTimeState();
  final String title;
  final DialogOpenCloseTimeCallback callback;
}

class _DialogOpenCloseTimeState extends State<DialogOpenCloseTime> {
  String selectedText;

  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.thLarge,
        color: MainTheme.enabledButtonColor,
        text: selectedText == null ? widget.title : selectedText,
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
                                .text("time_select")),
                        Material(
                            type: MaterialType.canvas,
                            child: Column(
                              children: <Widget>[
                                Text(LocalizableLoader.of(context)
                                    .text("open_time")),
                                Container(
                                    width: kDeviceWidth,
                                    height: 200,
                                    color: Colors.white,
                                    child: TimePickerSpinner(
                                      minutesInterval: 10,
                                      is24HourMode: false,
                                      normalTextStyle: TextStyle(
                                          fontSize: 24, color: Colors.black45),
                                      highlightedTextStyle: TextStyle(
                                          fontSize: 24,
                                          color: MainTheme.enabledButtonColor),
                                      spacing: 40,
                                      itemHeight: 50,
                                      isForce2Digits: true,
                                      onTimeChange: (time) {
                                        dialogOpenDateTime = time;
                                      },
                                    )),
                                Text(LocalizableLoader.of(context)
                                    .text("close_time")),
                                Container(
                                    width: kDeviceWidth,
                                    height: 200,
                                    color: Colors.white,
                                    child: TimePickerSpinner(
                                      minutesInterval: 10,
                                      is24HourMode: false,
                                      normalTextStyle: TextStyle(
                                          fontSize: 24, color: Colors.black45),
                                      highlightedTextStyle: TextStyle(
                                          fontSize: 24,
                                          color: MainTheme.enabledButtonColor),
                                      spacing: 40,
                                      itemHeight: 50,
                                      isForce2Digits: true,
                                      onTimeChange: (time) {
                                        dialogCloseDateTime = time;
                                      },
                                    )),
                              ],
                            )),
                        DialogBottomWidget(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            if (dialogOpenDateTime == null ||
                                dialogCloseDateTime == null) {
                              FailSnackbar().show(
                                  "error_clubInfo_form_select_time", null);

                              return;
                            }

                            if (widget.callback != null) {
                              DateFormat dateFormat = DateFormat("HH:mm a");
                              String openTime =
                                  dateFormat.format(dialogOpenDateTime);
                              String closeTime =
                                  dateFormat.format(dialogCloseDateTime);
                              String time = openTime + " ~ " + closeTime;
                              selectedText = time;

                              widget.callback(time);
                            }
                            Navigator.pop(context);
                          },
                        )
                      ])));
        });
  }
}

class DialogOpenCloseTimeContents extends StatefulWidget {
  @override
  _DialogOpenCloseTimeContentsState createState() =>
      _DialogOpenCloseTimeContentsState();
}

class _DialogOpenCloseTimeContentsState
    extends State<DialogOpenCloseTimeContents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[],
      ),
    );
  }

  onChangedValue(value) {
    setState(() {
      dialogPostType = value;
    });
  }
}

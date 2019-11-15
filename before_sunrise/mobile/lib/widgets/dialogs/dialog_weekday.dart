import 'package:before_sunrise/import.dart';

typedef DialogWeekDayCallback = void Function(String times);

String dialogWeekday = "";

class DialogWeekDay extends StatefulWidget {
  DialogWeekDay({@required this.callback});
  @override
  _DialogWeekDayState createState() => _DialogWeekDayState();
  final DialogWeekDayCallback callback;
}

class _DialogWeekDayState extends State<DialogWeekDay> {
  String selectedText;

  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.thLarge,
        color: MainTheme.enabledButtonColor,
        text: selectedText == null
            ? LocalizableLoader.of(context).text("weekday_select")
            : selectedText,
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
                                .text("weekday_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: Container(
                              width: kDeviceWidth,
                              height: 300,
                              child: ClubInfoStepAddress()),
                        ),
                        DialogBottomWidget(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            selectedText = LocalizableLoader.of(context)
                                .text("$dialogPostType");
                            if (widget.callback != null) {
                              widget.callback(dialogWeekday);
                            }
                            Navigator.pop(context);
                          },
                        )
                      ])));
        });
  }
}

class DialogWeekDayContents extends StatefulWidget {
  @override
  _DialogWeekDayContentsState createState() => _DialogWeekDayContentsState();
}

class _DialogWeekDayContentsState extends State<DialogWeekDayContents> {
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

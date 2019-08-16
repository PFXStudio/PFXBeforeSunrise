import 'package:before_sunrise/import.dart';

typedef DialogPublishTypeWidgetCallback = void Function(int index);

class DialogPublishTypeWidget extends StatefulWidget {
  DialogPublishTypeWidget({this.callback = null});
  @override
  _DialogPublishTypeWidgetState createState() =>
      _DialogPublishTypeWidgetState();
  DialogPublishTypeWidgetCallback callback;
}

class _DialogPublishTypeWidgetState extends State<DialogPublishTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.venusMars,
        color: MainTheme.enabledButtonColor,
        width: 170,
        text: LocalizableLoader.of(context).text("publish_type_select"),
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
                                .text("publish_type_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: DialogPublishTypeWidgetContentsWidget(),
                        ),
                        DialogBottomWidget(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            Navigator.pop(context);
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

class DialogPublishTypeWidgetContentsWidget extends StatefulWidget {
  @override
  _DialogPublishTypeWidgetContentsWidgetState createState() =>
      _DialogPublishTypeWidgetContentsWidgetState();
}

class _DialogPublishTypeWidgetContentsWidgetState
    extends State<DialogPublishTypeWidgetContentsWidget> {
  @override
  PublishType publishType = PublishType.all;
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title:
                Text(LocalizableLoader.of(context).text("${PublishType.all}")),
            leading: Radio(
              value: PublishType.all,
              groupValue: publishType,
              onChanged: (PublishType value) {
                setState(() {
                  publishType = value;
                });
              },
            ),
          ),
          ListTile(
            title:
                Text(LocalizableLoader.of(context).text("${PublishType.male}")),
            leading: Radio(
              value: PublishType.male,
              groupValue: publishType,
              onChanged: (PublishType value) {
                setState(() {
                  publishType = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(
                LocalizableLoader.of(context).text("${PublishType.female}")),
            leading: Radio(
              value: PublishType.female,
              groupValue: publishType,
              onChanged: (PublishType value) {
                setState(() {
                  publishType = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  onChangedValue(value) {
    setState(() {
      publishType = value;
    });
  }
}

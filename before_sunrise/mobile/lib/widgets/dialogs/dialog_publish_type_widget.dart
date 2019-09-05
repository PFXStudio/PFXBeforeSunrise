import 'package:before_sunrise/import.dart';

typedef DialogPublishTypeWidgetCallback = void Function(String type);

PublishType dialogPublishType = PublishType.all;

class DialogPublishTypeWidget extends StatefulWidget {
  DialogPublishTypeWidget({this.callback = null});
  @override
  _DialogPublishTypeWidgetState createState() =>
      _DialogPublishTypeWidgetState();
  DialogPublishTypeWidgetCallback callback;
}

class _DialogPublishTypeWidgetState extends State<DialogPublishTypeWidget> {
  @override
  String selectedText;
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.venusMars,
        color: MainTheme.enabledButtonColor,
        text: selectedText == null
            ? LocalizableLoader.of(context).text("publish_type_select")
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
                            selectedText = LocalizableLoader.of(context)
                                .text("$dialogPublishType");
                            if (widget.callback != null) {
                              widget.callback("$dialogPublishType");
                            }
                            Navigator.pop(context);
                          },
                        )
                      ])));
        });
  }
}

class DialogPublishTypeWidgetContentsWidget extends StatefulWidget {
  @override
  _DialogPublishTypeWidgetContentsWidgetState createState() =>
      _DialogPublishTypeWidgetContentsWidgetState();
}

class _DialogPublishTypeWidgetContentsWidgetState
    extends State<DialogPublishTypeWidgetContentsWidget> {
  @override
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
              groupValue: dialogPublishType,
              onChanged: onChangedValue,
            ),
          ),
          ListTile(
            title:
                Text(LocalizableLoader.of(context).text("${PublishType.male}")),
            leading: Radio(
              value: PublishType.male,
              groupValue: dialogPublishType,
              onChanged: onChangedValue,
            ),
          ),
          ListTile(
            title: Text(
                LocalizableLoader.of(context).text("${PublishType.female}")),
            leading: Radio(
              value: PublishType.female,
              groupValue: dialogPublishType,
              onChanged: onChangedValue,
            ),
          ),
        ],
      ),
    );
  }

  onChangedValue(value) {
    setState(() {
      dialogPublishType = value;
    });
  }
}

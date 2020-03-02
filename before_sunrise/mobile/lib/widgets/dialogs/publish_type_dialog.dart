import 'package:before_sunrise/import.dart';

typedef PublishTypeDialogCallback = void Function(String type);

PublishType dialogPublishType = PublishType.all;

class PublishTypeDialog extends StatefulWidget {
  PublishTypeDialog({this.callback = null});
  @override
  _PublishTypeDialogState createState() => _PublishTypeDialogState();
  PublishTypeDialogCallback callback;
}

class _PublishTypeDialogState extends State<PublishTypeDialog> {
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
                        HeaderDialog(
                            title: LocalizableLoader.of(context)
                                .text("publish_type_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: PublishTypeDialogContentsWidget(),
                        ),
                        BottomDialog(
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

class PublishTypeDialogContentsWidget extends StatefulWidget {
  @override
  _PublishTypeDialogContentsWidgetState createState() =>
      _PublishTypeDialogContentsWidgetState();
}

class _PublishTypeDialogContentsWidgetState
    extends State<PublishTypeDialogContentsWidget> {
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

import 'package:before_sunrise/import.dart';

typedef AddressDialogCallback = void Function(String address);

String dialogAddress = "";

class AddressDialog extends StatefulWidget {
  AddressDialog({@required this.callback});
  @override
  _AddressDialogState createState() => _AddressDialogState();
  final AddressDialogCallback callback;
}

class _AddressDialogState extends State<AddressDialog> {
  String selectedText;

  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.thLarge,
        color: MainTheme.enabledButtonColor,
        text: selectedText == null
            ? LocalizableLoader.of(context).text("post_type_hint")
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
                                .text("post_type_hint")),
                        Material(
                          type: MaterialType.transparency,
                          child: Container(
                              width: kDeviceWidth,
                              height: 300,
                              child: ClubInfoStepAddress()),
                        ),
                        BottomDialog(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            selectedText = LocalizableLoader.of(context)
                                .text("$dialogPostType");
                            if (widget.callback != null) {
                              widget.callback(dialogAddress);
                            }
                            Navigator.pop(context);
                          },
                        )
                      ])));
        });
  }
}

class AddressDialogContents extends StatefulWidget {
  @override
  _AddressDialogContentsState createState() => _AddressDialogContentsState();
}

class _AddressDialogContentsState extends State<AddressDialogContents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(LocalizableLoader.of(context).text("${PostType.free}")),
            leading: Radio(
              value: PostType.free,
              groupValue: dialogPostType,
              onChanged: onChangedValue,
            ),
          ),
          ListTile(
            title: Text(
                LocalizableLoader.of(context).text("${PostType.realTime}")),
            leading: Radio(
              value: PostType.realTime,
              groupValue: dialogPostType,
              onChanged: onChangedValue,
            ),
          ),
          ListTile(
            title:
                Text(LocalizableLoader.of(context).text("${PostType.gallery}")),
            leading: Radio(
              value: PostType.gallery,
              groupValue: dialogPostType,
              onChanged: onChangedValue,
            ),
          ),
        ],
      ),
    );
  }

  onChangedValue(value) {
    setState(() {
      dialogPostType = value;
    });
  }
}

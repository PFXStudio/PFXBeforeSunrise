import 'package:before_sunrise/import.dart';

typedef DialogClubInfoAddressCallback = void Function(String address);

String dialogAddress = "";

class DialogClubInfoAddress extends StatefulWidget {
  DialogClubInfoAddress({@required this.callback});
  @override
  _DialogClubInfoAddressState createState() => _DialogClubInfoAddressState();
  final DialogClubInfoAddressCallback callback;
}

class _DialogClubInfoAddressState extends State<DialogClubInfoAddress> {
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
                        DialogHeaderWidget(
                            title: LocalizableLoader.of(context)
                                .text("post_type_hint")),
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
                              widget.callback(dialogAddress);
                            }
                            Navigator.pop(context);
                          },
                        )
                      ])));
        });
  }
}

class DialogClubInfoAddressContents extends StatefulWidget {
  @override
  _DialogClubInfoAddressContentsState createState() =>
      _DialogClubInfoAddressContentsState();
}

class _DialogClubInfoAddressContentsState
    extends State<DialogClubInfoAddressContents> {
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

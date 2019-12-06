import 'package:before_sunrise/import.dart';

typedef PostTypeDialogCallback = void Function(String type);

PostType dialogPostType = PostType.free;

class PostTypeDialog extends StatefulWidget {
  PostTypeDialog({@required this.callback = null});
  @override
  _PostTypeDialogState createState() => _PostTypeDialogState();
  PostTypeDialogCallback callback;
}

class _PostTypeDialogState extends State<PostTypeDialog> {
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
                          child: PostTypeDialogContents(),
                        ),
                        BottomDialog(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            selectedText = LocalizableLoader.of(context)
                                .text("$dialogPostType");
                            if (widget.callback != null) {
                              widget.callback("$dialogPostType");
                            }
                            Navigator.pop(context);
                          },
                        )
                      ])));
        });
  }
}

class PostTypeDialogContents extends StatefulWidget {
  @override
  _PostTypeDialogContentsState createState() => _PostTypeDialogContentsState();
}

class _PostTypeDialogContentsState extends State<PostTypeDialogContents> {
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

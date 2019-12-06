import 'package:before_sunrise/import.dart';

typedef GenreTypeDialogCallback = void Function(int type);

int dialogGenreType = 0;

class GenreTypeDialog extends StatefulWidget {
  GenreTypeDialog({@required this.callback = null});
  @override
  _GenreTypeDialogState createState() => _GenreTypeDialogState();
  GenreTypeDialogCallback callback;
}

class _GenreTypeDialogState extends State<GenreTypeDialog> {
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
                          child: GenreTypeDialogContents(),
                        ),
                        BottomDialog(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            selectedText = LocalizableLoader.of(context)
                                .text("$dialogPostType");
                            if (widget.callback != null) {
                              widget.callback(dialogGenreType);
                            }
                            Navigator.pop(context);
                          },
                        )
                      ])));
        });
  }
}

class GenreTypeDialogContents extends StatefulWidget {
  @override
  _GenreTypeDialogContentsState createState() =>
      _GenreTypeDialogContentsState();
}

class _GenreTypeDialogContentsState extends State<GenreTypeDialogContents> {
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

import 'package:before_sunrise/import.dart';

typedef DialogClubInfoGenreTypeCallback = void Function(int type);

int dialogGenreType = 0;

class DialogClubInfoGenreType extends StatefulWidget {
  DialogClubInfoGenreType({@required this.callback = null});
  @override
  _DialogClubInfoGenreTypeState createState() =>
      _DialogClubInfoGenreTypeState();
  DialogClubInfoGenreTypeCallback callback;
}

class _DialogClubInfoGenreTypeState extends State<DialogClubInfoGenreType> {
  String selectedText;

  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.thLarge,
        color: MainTheme.enabledButtonColor,
        text: selectedText == null
            ? LocalizableLoader.of(context).text("post_type_select")
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
                                .text("post_type_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: DialogClubInfoGenreTypeContents(),
                        ),
                        DialogBottomWidget(
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

class DialogClubInfoGenreTypeContents extends StatefulWidget {
  @override
  _DialogClubInfoGenreTypeContentsState createState() =>
      _DialogClubInfoGenreTypeContentsState();
}

class _DialogClubInfoGenreTypeContentsState
    extends State<DialogClubInfoGenreTypeContents> {
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

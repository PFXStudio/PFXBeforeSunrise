import 'package:before_sunrise/import.dart';

typedef PostFormOptionCallback = void Function(int index);

class PostFormOption extends StatefulWidget {
  PostFormOption({this.callback = null});
  @override
  _PostFormOptionState createState() => _PostFormOptionState();
  PostFormOptionCallback callback;
}

class _PostFormOptionState extends State<PostFormOption> {
  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.thLarge,
        color: MainTheme.enabledButtonColor,
        width: 170,
        text: LocalizableLoader.of(context).text("board_type_select"),
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
                                .text("board_type_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: PostFormOptionContentsWidget(),
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

class PostFormOptionContentsWidget extends StatefulWidget {
  @override
  _PostFormOptionContentsWidgetState createState() =>
      _PostFormOptionContentsWidgetState();
}

class _PostFormOptionContentsWidgetState
    extends State<PostFormOptionContentsWidget> {
  @override
  PostType postType = PostType.free;
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
                LocalizableLoader.of(context).text("${PostType.realTime}")),
            leading: Radio(
              value: PostType.realTime,
              groupValue: postType,
              onChanged: (PostType value) {
                setState(() {
                  postType = value;
                });
              },
            ),
          ),
          ListTile(
            title:
                Text(LocalizableLoader.of(context).text("${PostType.gallery}")),
            leading: Radio(
              value: PostType.gallery,
              groupValue: postType,
              onChanged: (PostType value) {
                setState(() {
                  postType = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(LocalizableLoader.of(context).text("${PostType.free}")),
            leading: Radio(
              value: PostType.free,
              groupValue: postType,
              onChanged: (PostType value) {
                setState(() {
                  postType = value;
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
      postType = value;
    });
  }
}

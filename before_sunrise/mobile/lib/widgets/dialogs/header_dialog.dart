import 'package:before_sunrise/import.dart';

class HeaderDialog extends StatefulWidget {
  @override
  _HeaderDialogState createState() => _HeaderDialogState();
  HeaderDialog({this.title});

  String title = "";
}

class _HeaderDialogState extends State<HeaderDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        color: MainTheme.bgndColor,
        child: Material(
            type: MaterialType.button,
            color: Colors.transparent,
            child: InkWell(
              borderRadius: kMaterialEdges[MaterialType.button],
              highlightColor: MainTheme.enabledButtonColor,
              splashColor: Colors.transparent,
              onTap: () {},
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            )));
  }
}

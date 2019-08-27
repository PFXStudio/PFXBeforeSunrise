import 'package:before_sunrise/import.dart';

class FlatIconTextButton extends StatefulWidget {
  FlatIconTextButton(
      {this.iconData = Icons.ac_unit,
      this.color = Colors.red,
      this.width = 100,
      this.text = "null",
      this.onPressed = null});
  @override
  _FlatIconTextButtonState createState() => _FlatIconTextButtonState();
  IconData iconData = Icons.ac_unit;
  Color color = Colors.red;
  double width = 100;
  String text = "";
  VoidCallback onPressed;
}

class _FlatIconTextButtonState extends State<FlatIconTextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 40,
      child: FlatButton(
        padding: EdgeInsets.only(
          left: 15,
          right: 5,
          top: 5,
        ),
        onPressed: widget.onPressed,
        child: Row(
          // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Icon(
              widget.iconData,
              color: widget.color,
              size: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 7),
            ),
            Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: widget.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

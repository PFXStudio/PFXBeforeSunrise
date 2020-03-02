import 'package:before_sunrise/import.dart';

class FlatIconTextButton extends StatefulWidget {
  FlatIconTextButton(
      {this.iconData = FontAwesomeIcons.child,
      this.color = Colors.black,
      this.width = 200,
      this.text = "null",
      this.enabled = true,
      this.onPressed});
  @override
  _FlatIconTextButtonState createState() => _FlatIconTextButtonState();
  final IconData iconData;
  final Color color;
  final double width;
  final String text;
  final bool enabled;
  final VoidCallback onPressed;
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
        ),
        onPressed: widget.enabled == true ? widget.onPressed : () => {},
        child: Row(
          // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Icon(
              widget.iconData,
              color: widget.enabled == false
                  ? MainTheme.disabledButtonColor
                  : widget.color,
              size: 18,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(widget.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: widget.enabled == false
                          ? MainTheme.disabledButtonColor
                          : widget.color,
                      fontSize: 13)),
            )
          ],
        ),
      ),
    );
  }
}

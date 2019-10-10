import 'package:before_sunrise/import.dart';
import 'package:flutter/cupertino.dart';

class KeyboardItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Text("Done",
                style: TextStyle(
                    color: MainTheme.enabledButtonColor,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

import 'package:before_sunrise/import.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Center(
        child: SizedBox(
            width: 120,
            height: 33,
            child: Row(
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Text(LocalizableLoader.of(context).text("loading")),
              ],
            )),
      ),
    );
  }
}

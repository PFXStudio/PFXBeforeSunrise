import 'package:before_sunrise/import.dart';

class PostFormTopBar extends StatefulWidget {
  @override
  PostFormTopBarState createState() => PostFormTopBarState();
}

class PostFormTopBarState extends State<PostFormTopBar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _touchedCloseButton() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MainTheme.appBarColor,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        LocalizableLoader.of(context).text("board_regist_title"),
        style: MainTheme.navTitleTextStyle,
      ),
    );
  }
}

import 'package:before_sunrise/import.dart';

class ClubInfoStepBar extends StatefulWidget implements PreferredSizeWidget {
  ClubInfoStepBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _ClubInfoStepBarState createState() => _ClubInfoStepBarState();
}

class _ClubInfoStepBarState extends State<ClubInfoStepBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MainTheme.appBarColor,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.angleLeft),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        LocalizableLoader.of(context).text("regist"),
        style: MainTheme.navTitleTextStyle,
      ),
    );
  }
}

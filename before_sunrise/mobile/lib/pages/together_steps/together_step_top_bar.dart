import 'package:before_sunrise/import.dart';

class TogetherStepTopBar extends StatefulWidget {
  @override
  _BoardTopBarWidgetState createState() => _BoardTopBarWidgetState();
}

class _BoardTopBarWidgetState extends State<TogetherStepTopBar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      title: Text(LocalizableLoader.of(context).text("regist")),
    );
  }
}

class _Title extends StatelessWidget {
  _Title(this.toggleTheaters);
  final VoidCallback toggleTheaters;

  @override
  Widget build(BuildContext context) {
    final subtitle = Text("subtitle");

    final title = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Test'),
        subtitle,
      ],
    );

    return GestureDetector(
      onTap: toggleTheaters,
      child: Row(
        children: [
          // Image.asset('assets/images/logo.png', width: 28.0, height: 28.0),
          // const SizedBox(width: 8.0),
          // title,
        ],
      ),
    );
  }
}

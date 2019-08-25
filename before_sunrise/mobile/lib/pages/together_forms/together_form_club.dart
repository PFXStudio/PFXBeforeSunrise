import 'package:before_sunrise/import.dart';

typedef TogetherFormClubCallback = void Function(int index);

class TogetherFormClub extends StatefulWidget {
  TogetherFormClub({this.callback = null});
  @override
  _TogetherFormClubState createState() => _TogetherFormClubState();
  TogetherFormClubCallback callback;
}

class _TogetherFormClubState extends State<TogetherFormClub> {
  double selectedPrice = 0;

  Widget _buildContents(BuildContext context) {
    return Container(
        height: 250,
        color: Colors.white,
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black26,
                ),
            scrollDirection: Axis.vertical,
            itemCount: DefineStrings.clubNames.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    DefineStrings.clubNames[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.mapMarkerAlt,
        color: MainTheme.enabledButtonColor,
        width: 170,
        text: LocalizableLoader.of(context).text("club_name_select"),
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
                                .text("club_name_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: _buildContents(context),
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

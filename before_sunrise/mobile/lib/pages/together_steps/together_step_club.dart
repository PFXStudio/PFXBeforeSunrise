import 'package:before_sunrise/import.dart';

typedef TogetherStepClubCallback = void Function(String clubID);

class TogetherStepClub extends StatefulWidget {
  TogetherStepClub({this.callback, this.editSelectedClubID});
  @override
  _TogetherStepClubState createState() => _TogetherStepClubState();
  final TogetherStepClubCallback callback;
  String editSelectedClubID;
}

class _TogetherStepClubState extends State<TogetherStepClub> {
  @override
  void dispose() {
    super.dispose();
  }

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
              return GestureDetector(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      DefineStrings.clubNames[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    )),
                onTap: () {
                  widget.editSelectedClubID = DefineStrings.clubNames[index];
                  Navigator.pop(context);
                  if (widget.callback == null) {
                    return;
                  }

                  widget.callback(widget.editSelectedClubID);
                  setState(() {});
                },
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.mapMarkerAlt,
        color: MainTheme.enabledButtonColor,
        text: widget.editSelectedClubID != null &&
                widget.editSelectedClubID.length > 0
            ? widget.editSelectedClubID
            : LocalizableLoader.of(context).text("club_select_hint"),
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
                        HeaderDialog(
                            title: LocalizableLoader.of(context)
                                .text("club_select_hint")),
                        Material(
                          type: MaterialType.transparency,
                          child: _buildContents(context),
                        ),
                        BottomDialog(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            Navigator.pop(context);
                            if (widget.callback == null) {
                              return;
                            }

                            widget.callback(widget.editSelectedClubID);
                            setState(() {});
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

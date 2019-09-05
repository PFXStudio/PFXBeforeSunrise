import 'package:before_sunrise/import.dart';

typedef DialogGenderTypeWidgetCallback = void Function(GenderType genderType);
GenderType genderType = GenderType.MAX;

class DialogGenderTypeWidget extends StatefulWidget {
  DialogGenderTypeWidget({this.callback = null});
  @override
  _DialogGenderTypeWidgetState createState() => _DialogGenderTypeWidgetState();
  DialogGenderTypeWidgetCallback callback;
}

class _DialogGenderTypeWidgetState extends State<DialogGenderTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        iconData: FontAwesomeIcons.venusMars,
        color: MainTheme.enabledButtonColor,
        text: LocalizableLoader.of(context).text("gender_type_select"),
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
                                .text("gender_type_select")),
                        Material(
                          type: MaterialType.transparency,
                          child: DialogGenderTypeWidgetContentsWidget(),
                        ),
                        DialogBottomWidget(
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                          confirmCallback: () {
                            if (genderType != GenderType.MAX) {
                              widget.callback(genderType);
                            }

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

class DialogGenderTypeWidgetContentsWidget extends StatefulWidget {
  @override
  _DialogGenderTypeWidgetContentsWidgetState createState() =>
      _DialogGenderTypeWidgetContentsWidgetState();
}

class _DialogGenderTypeWidgetContentsWidgetState
    extends State<DialogGenderTypeWidgetContentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title:
                Text(LocalizableLoader.of(context).text("${GenderType.male}")),
            leading: Radio(
              value: GenderType.male,
              groupValue: genderType,
              onChanged: (GenderType value) {
                setState(() {
                  genderType = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(
                LocalizableLoader.of(context).text("${GenderType.female}")),
            leading: Radio(
              value: GenderType.female,
              groupValue: genderType,
              onChanged: (GenderType value) {
                setState(() {
                  genderType = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  onChangedValue(value) {
    setState(() {
      genderType = value;
    });
  }
}

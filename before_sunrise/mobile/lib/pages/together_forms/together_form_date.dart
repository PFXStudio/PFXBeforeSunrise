import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

typedef TogetherFormDateCallback = void Function(String dateString);

class TogetherFormDate extends StatefulWidget {
  TogetherFormDate({this.callback});
  @override
  _TogetherFormDateState createState() => _TogetherFormDateState();
  final TogetherFormDateCallback callback;
}

class _TogetherFormDateState extends State<TogetherFormDate> {
  DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return FlatIconTextButton(
      iconData: FontAwesomeIcons.calendar,
      color: MainTheme.enabledButtonColor,
      width: 150,
      text: selectedDate != null
          ? CoreConst.togetherDateFormat.format(selectedDate)
          : LocalizableLoader.of(context).text("date_select"),
      onPressed: () async {
        final date = await showDatePicker(
            context: context,
            firstDate: now.add(Duration(days: -1)),
            initialDate: now,
            lastDate: now.add(Duration(days: 5)));
        setState(() {
          selectedDate = date;
        });
        if (widget.callback == null) {
          return;
        }

        widget.callback(CoreConst.togetherDateFormat.format(selectedDate));
      },
    );
  }
}

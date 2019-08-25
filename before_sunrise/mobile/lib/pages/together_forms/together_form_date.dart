import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

typedef TogetherFormDateCallback = void Function(DateTime dateTime);

class TogetherFormDate extends StatefulWidget {
  TogetherFormDate({this.callback = null});
  @override
  _TogetherFormDateState createState() => _TogetherFormDateState();
  TogetherFormDateCallback callback;
}

class _TogetherFormDateState extends State<TogetherFormDate> {
  final format = DateFormat("yyyy-MM-dd");
  DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    print(selectedDate);
    DateTime now = DateTime.now();
    return FlatIconTextButton(
      iconData: FontAwesomeIcons.calendar,
      color: MainTheme.enabledButtonColor,
      width: 150,
      text: LocalizableLoader.of(context).text("date_select"),
      onPressed: () async {
        final date = await showDatePicker(
            context: context,
            firstDate: now,
            initialDate: now,
            lastDate: now.add(Duration(days: 6)));
        selectedDate = date;
      },
    );
  }
}

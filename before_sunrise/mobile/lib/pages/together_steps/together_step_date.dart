import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

typedef TogetherStepDateCallback = void Function(DateTime dateTime);

class TogetherStepDate extends StatefulWidget {
  TogetherStepDate({this.callback, this.editSelectedDate});
  @override
  _TogetherStepDateState createState() => _TogetherStepDateState();
  final TogetherStepDateCallback callback;
  DateTime editSelectedDate;
}

class _TogetherStepDateState extends State<TogetherStepDate> {
  DateTime selectedDate() => widget.editSelectedDate;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return FlatIconTextButton(
      iconData: FontAwesomeIcons.calendar,
      color: MainTheme.enabledButtonColor,
      text: selectedDate() != null
          ? CoreConst.togetherDateTextFormat.format(selectedDate())
          : LocalizableLoader.of(context).text("date_select_hint"),
      onPressed: () async {
        final date = await showDatePicker(
            context: context,
            firstDate: now.add(Duration(days: -1)),
            initialDate: now,
            lastDate: now.add(Duration(days: 5)));
        setState(() {
          widget.editSelectedDate = date;
        });
        if (widget.callback == null) {
          return;
        }

        widget.callback(selectedDate());
      },
    );
  }
}

import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

class TogetherDateSelector extends StatefulWidget {
  TogetherDateSelector(this.dates, this.selectedDate, this.changedDateTime);
  final List<DateTime> dates;
  DateTime selectedDate;
  final Function(DateTime) changedDateTime;

  @override
  _TogetherDateSelectorState createState() => _TogetherDateSelectorState();
}

class _TogetherDateSelectorState extends State<TogetherDateSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF8C5B8),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      height: 56.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.dates.map((date) {
            final isSelected = date == widget.selectedDate;
            final backgroundColor =
                isSelected ? MainTheme.enabledButtonColor : Colors.transparent;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              color: backgroundColor,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    widget.selectedDate = date;
                    widget.changedDateTime(date);
                    setState(() {});
                  },
                  radius: 56.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _ItemContent(date, isSelected),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ItemContent extends StatelessWidget {
  static final dateFormat = DateFormat('E');

  _ItemContent(this.date, this.isSelected);
  final DateTime date;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final dayColor = isSelected ? Colors.white : Colors.black54;
    final dateColor = isSelected ? Colors.white : Colors.black54;
    final dateWeight = isSelected ? FontWeight.w500 : FontWeight.w300;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: dayColor,
          ),
          child: Text(dateFormat.format(date)),
        ),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: dateWeight,
            color: dateColor,
          ),
          child: Text(date.day.toString()),
        ),
      ],
    );
  }
}

import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

class TogetherDateSelector extends StatelessWidget {
  TogetherDateSelector(this.togetherCollection, this.changedDateTime);
  final TogetherCollection togetherCollection;
  final Function(DateTime) changedDateTime;

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
          children: togetherCollection.dates.map((date) {
            return _DateSelectorItem(date, togetherCollection, changedDateTime);
          }).toList(),
        ),
      ),
    );
  }
}

class _DateSelectorItem extends StatelessWidget {
  _DateSelectorItem(
    this.date,
    this.viewModel,
    this.changedDateTime,
  );

  final DateTime date;
  final TogetherCollection viewModel;
  final Function(DateTime) changedDateTime;

  @override
  Widget build(BuildContext context) {
    final isSelected = date == viewModel.selectedDate;
    final backgroundColor =
        isSelected ? MainTheme.enabledButtonColor : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      color: backgroundColor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO :
            changedDateTime(date);
          },
          radius: 56.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _ItemContent(date, isSelected),
          ),
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

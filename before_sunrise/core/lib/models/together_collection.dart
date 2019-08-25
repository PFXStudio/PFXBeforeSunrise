import 'package:core/import.dart';

class TogetherCollection {
  TogetherCollection({
    @required this.dates,
    @required this.selectedDate,
    @required this.togethers,
  });

  List<DateTime> dates;
  final DateTime selectedDate;
  final List<Together> togethers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TogetherCollection &&
          runtimeType == other.runtimeType &&
          dates == other.dates &&
          selectedDate == other.selectedDate &&
          togethers == other.togethers;

  @override
  int get hashCode =>
      dates.hashCode ^ selectedDate.hashCode ^ togethers.hashCode;
}

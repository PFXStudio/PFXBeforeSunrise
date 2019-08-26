import 'package:core/import.dart';

class TogetherCollection {
  TogetherCollection({
    @required this.selectedDate,
    @required this.togethers,
  });

  final DateTime selectedDate;
  final List<Together> togethers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TogetherCollection &&
          runtimeType == other.runtimeType &&
          selectedDate == other.selectedDate &&
          togethers == other.togethers;

  @override
  int get hashCode => selectedDate.hashCode ^ togethers.hashCode;
}

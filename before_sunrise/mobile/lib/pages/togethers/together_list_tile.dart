import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

// @visibleForTesting
// Function(String) launchTicketsUrl = (url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   }
// };

class TogetherListTile extends StatelessWidget {
  TogetherListTile(
    this.together, {
    this.opensEventDetails = true,
  });

  final Together together;
  final bool opensEventDetails;

  void _navigateToEventDetails(BuildContext context) {
    // final event = eventForTogetherSelector(store.state, together);

    // Navigator.push<Null>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => EventDetailsPage(event, together: together),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final onTap =
        opensEventDetails ? () => _navigateToEventDetails(context) : null;

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      child: Row(
        children: [
          _TogethertimesInfo(together),
          _DetailedInfo(together),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 1.0),
      child: Material(
        color: const Color(0xE00D1736),
        child: InkWell(
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}

class _TogethertimesInfo extends StatelessWidget {
  static final hoursAndMins = DateFormat('HH:mm');

  _TogethertimesInfo(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          hoursAndMins.format(together.lastUpdate),
          style: const TextStyle(
            fontSize: 18.0,
            color: const Color(0xFFFEFEFE),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          hoursAndMins.format(together.lastUpdate),
          style: const TextStyle(
            fontSize: 14.0,
            color: const Color(0xFF717DAD),
          ),
        ),
      ],
    );
  }
}

class _DetailedInfo extends StatelessWidget {
  _DetailedInfo(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    final decoration = const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Color(0xFF717DAD),
        ),
      ),
    );

    final content = [
      Text(
        together.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          color: const Color(0xFFFEFEFE),
        ),
      ),
      const SizedBox(height: 4.0),
      Text(
        together.contents,
        style: const TextStyle(
          color: Color(0xFF717DAD),
        ),
      ),
      _PresentationMethodChip(together),
    ];

    return Expanded(
      child: Container(
        decoration: decoration,
        margin: const EdgeInsets.only(left: 12.0),
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: content,
        ),
      ),
    );
  }
}

class _PresentationMethodChip extends StatelessWidget {
  _PresentationMethodChip(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF21316B),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Text(
        together.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          color: Color(0xFFFEFEFE),
        ),
      ),
    );
  }
}

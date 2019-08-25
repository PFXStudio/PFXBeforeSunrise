import 'package:before_sunrise/import.dart';

class TogetherListPage extends StatelessWidget {
  TogetherListPage({@required this.togethers});
  List<Together> togethers;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      key: Key('content'),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 50.0),
        itemCount: togethers.length,
        itemBuilder: (BuildContext context, int index) {
          final together = togethers[index];
          return TogetherListTile(together);
        },
      ),
    );
  }
}

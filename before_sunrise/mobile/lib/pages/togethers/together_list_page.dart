import 'package:before_sunrise/import.dart';

class TogetherListPage extends StatelessWidget {
  TogetherListPage({@required this.togethers});
  List<Together> togethers;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisChildCount = isPortrait ? 2 : 4;

    return Container(
        key: Key("together_list_page_grid"),
        child: Scrollbar(
            child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 50.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisChildCount,
            childAspectRatio: 9 / 10,
          ),
          itemCount: togethers.length,
          itemBuilder: _buildItem,
        )));

    // return Scrollbar(
    //   key: Key('content'),
    //   child: ListView.builder(
    //     padding: const EdgeInsets.only(bottom: 50.0),
    //     itemCount: togethers.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       final together = togethers[index];
    //       return TogetherListTile(together);
    //     },
    //   ),
    // );
  }

  Widget _buildItem(BuildContext context, int index) {
    final together = togethers[index];

    return TogetherGridItem(
      together: together,
      onTapped: () {},
    );
  }
}

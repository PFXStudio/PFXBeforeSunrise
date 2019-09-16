import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/together_details/together_detail_widget.dart';

class TogetherListPage extends StatelessWidget {
  TogetherListPage({@required this.togethers, @required this.isBottomLoading});
  List<Together> togethers;
  bool isBottomLoading = false;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisChildCount = isPortrait ? 2 : 4;

    return Container(
        key: Key("together_list_page_grid"),
        padding: EdgeInsets.only(bottom: 150),
        child: Scrollbar(
            child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 50.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisChildCount,
            childAspectRatio: 8 / 10,
          ),
          itemCount: togethers.length + 1,
          itemBuilder: _buildItem,
        )));
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == togethers.length) {
      return Center(child: isBottomLoading ? BottomLoader() : Container());
    }

    final together = togethers[index];
    return TogetherGridItem(
        together: together,
        onTapped: () {
          TogetherBloc().dispatch(ViewTogetherEvent(
              together: together, userID: ProfileBloc().signedProfile.userID));
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TogetherDetailWidget(together),
              ));
        });
  }
}

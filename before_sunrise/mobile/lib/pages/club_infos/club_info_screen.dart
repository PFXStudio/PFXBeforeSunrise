import 'package:before_sunrise/import.dart';

class ClubInfoScreen extends StatefulWidget {
  const ClubInfoScreen({
    Key key,
  }) : super(key: key);

  @override
  ClubInfoScreenState createState() {
    return new ClubInfoScreenState();
  }
}

List _elements = [
  {'name': 'John', 'group': 'Team A'},
  {'name': 'Will', 'group': 'Team B'},
  {'name': 'Beth', 'group': 'Team A'},
  {'name': 'Miranda', 'group': 'Team B'},
  {'name': 'Mike', 'group': 'Team C'},
  {'name': 'Danny', 'group': 'Team C'},
];

class ClubInfoScreenState extends State<ClubInfoScreen> {
  ClubInfoScreenState();

  final _clubInfoBloc = ClubInfoBloc();

  @override
  void initState() {
    super.initState();
    this._clubInfoBloc.dispatch(LoadClubInfoEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<ClubInfoBloc, ClubInfoState>(
            bloc: _clubInfoBloc,
            builder: (
              BuildContext context,
              ClubInfoState currentState,
            ) {
              return GroupedListView(
                elements: _elements,
                groupBy: (element) => element['group'],
                groupSeparatorBuilder: _buildGroupSeparator,
                itemBuilder: (context, element) => Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Icon(Icons.account_circle),
                      title: Text(element['name']),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              );
            }));
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        groupByValue,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

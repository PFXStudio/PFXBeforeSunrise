import 'package:before_sunrise/import.dart';

class ProfileInputPage extends StatelessWidget {
  ProfileInputPage(this.userID);
  static const String routeName = "/profileInput";
  final String userID;

  @override
  Widget build(BuildContext context) {
    var _profileBloc = new ProfileBloc();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Profile"),
      ),
      body: new ProfileInputScreen(
        profileBloc: _profileBloc,
        userID: userID,
      ),
    );
  }
}

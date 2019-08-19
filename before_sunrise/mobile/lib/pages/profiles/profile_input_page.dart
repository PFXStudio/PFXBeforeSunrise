import 'package:before_sunrise/import.dart';

class ProfileInputPage extends StatelessWidget {
  static const String routeName = "/profileInput";

  @override
  Widget build(BuildContext context) {
    var _profileBloc = new ProfileBloc();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ProfileInput"),
      ),
      body: new ProfileInputScreen(profileBloc: _profileBloc),
    );
  }
}

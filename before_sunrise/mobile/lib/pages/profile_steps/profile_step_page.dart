import 'package:before_sunrise/import.dart';

class ProfileStepPage extends StatelessWidget {
  ProfileStepPage(this.userID);
  static const String routeName = "/profileInput";
  final String userID;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("Profile"),
      ),
      body: new ProfileStepScreen(userID: userID),
    );
  }
}

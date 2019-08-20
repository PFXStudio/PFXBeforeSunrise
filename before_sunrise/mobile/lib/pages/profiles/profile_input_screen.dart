import 'package:before_sunrise/import.dart';

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen(
      {Key key, @required ProfileBloc profileBloc, @required this.userID})
      : _profileBloc = profileBloc,
        super(key: key);

  final ProfileBloc _profileBloc;
  final String userID;

  @override
  ProfileInputScreenState createState() {
    return new ProfileInputScreenState(_profileBloc);
  }
}

class ProfileInputScreenState extends State<ProfileInputScreen> {
  final ProfileBloc _profileBloc;
  ProfileInputScreenState(this._profileBloc);

  @override
  void initState() {
    super.initState();
    this._profileBloc.dispatch(LoadProfileEvent(userID: widget.userID));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget._profileBloc,
        listener: (context, state) async {
          if (state is InProfileState) {
            Navigator.pushReplacementNamed(context, PostPage.routeName);

            return;
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: widget._profileBloc,
            builder: (
              BuildContext context,
              ProfileState currentState,
            ) {
              if (currentState is UnProfileState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (currentState is ErrorProfileState) {
                return new Container(
                    child: new Center(
                  child: new Text(currentState.errorMessage ?? 'Error'),
                ));
              }
              return new Container(
                  child: new Center(
                child: new Text("В разработке"),
              ));
            }));
  }
}

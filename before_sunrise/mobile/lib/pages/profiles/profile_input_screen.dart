import 'package:before_sunrise/import.dart';

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({Key key, @required this.userID}) : super(key: key);
  final String userID;

  @override
  ProfileInputScreenState createState() {
    return new ProfileInputScreenState();
  }
}

class ProfileInputScreenState extends State<ProfileInputScreen> {
  final ProfileBloc _profileBloc = ProfileBloc();
  ProfileInputScreenState();
  TextEditingController nicknameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  Asset _asset;
  GenderType genderType = GenderType.MAX;

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
    initializeDeviceSize(context);
    return BlocListener(
        bloc: _profileBloc,
        listener: (context, state) async {
          if (state is InProfileState) {
            ProfileBloc().signedProfile = state.profile.copyWith();
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);

            return;
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (
              BuildContext context,
              ProfileState currentState,
            ) {
              if (currentState is UnProfileState) {
                return SingleChildScrollView(
                    child: Container(
                  width: kDeviceWidth,
                  height: kDeviceHeight >= 655.0 ? kDeviceHeight : 655.0,
                  decoration: new BoxDecoration(
                    gradient: MainTheme.primaryLinearGradient,
                  ),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Card(
                            margin: EdgeInsets.all(30),
                            elevation: 2.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(top: 30),
                              height: 500.0,
                              child: Column(
                                children: <Widget>[
                                  Stack(children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(60.0)),
                                        border: new Border.all(
                                          color: Colors.black26,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(ProfileBloc()
                                                    .signedProfile !=
                                                null
                                            ? ProfileBloc()
                                                .signedProfile
                                                .imageUrl
                                            : "https://avatars1.githubusercontent.com/u/13096942?s=460&v=4"),
                                        foregroundColor: Colors.white,
                                        radius: 50.0,
                                      ),
                                    ),
                                    IconButton(
                                      padding:
                                          EdgeInsets.only(top: 80, left: 80),
                                      icon: Icon(FontAwesomeIcons.edit),
                                      onPressed: () {
                                        _loadAssets();
                                      },
                                      color: Colors.black54,
                                    )
                                  ]),
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.mobileAlt),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextField(
                                      focusNode: nicknameFocusNode,
                                      controller: nicknameController,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.child,
                                          color: Colors.black87,
                                          size: 16,
                                        ),
                                        hintText: "Nickname",
                                        hintStyle: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250.0,
                                    height: 1.0,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextField(
                                      focusNode: descriptionFocusNode,
                                      controller: descriptionController,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.idCard,
                                          color: Colors.black87,
                                          size: 16,
                                        ),
                                        hintText: "Description",
                                        hintStyle: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250.0,
                                    height: 1.0,
                                    color: Colors.grey[400],
                                  ),
                                  Container(
                                    width: kDeviceWidth -
                                        MainTheme.edgeInsets.left,
                                    height: 60,
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                  // Container(
                                  //   width: 250.0,
                                  //   height: 1.0,
                                  //   color: Colors.grey[400],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 505.0),
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: MainTheme.gradientStartColor,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                                BoxShadow(
                                  color: MainTheme.gradientEndColor,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                              ],
                              gradient: MainTheme.buttonLinearGradient,
                            ),
                            child: MaterialButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.red,
                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 42.0),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                onPressed: touchedConfirmButton),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
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

  Future touchedConfirmButton() async {
    if (nicknameController.text.length < 4 ||
        nicknameController.text.length > 12) {
      return;
    }

    if (genderType == GenderType.MAX) {
      return;
    }

    Profile updateProfile = Profile();
    updateProfile.userID = await AuthBloc().getUserID();
    updateProfile.phoneNumber = await AuthBloc().getPhoneNumber();
    updateProfile.nickname = nicknameController.text;
    updateProfile.description = descriptionController.text;
    updateProfile.imageUrl = "";
    _profileBloc.dispatch(UpdateProfileEvent(profile: updateProfile));
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );

      if (resultList.length <= 0) {
        return;
      }

      _asset = resultList.first;
      Profile updateProfile = Profile();
      updateProfile.userID = await AuthBloc().getUserID();
      updateProfile.phoneNumber = await AuthBloc().getPhoneNumber();
      _profileBloc.dispatch(UpdateProfileEvent(profile: updateProfile));
    } on PlatformException catch (e) {
      error = e.message;
      print(e.message);
    }
  }
}

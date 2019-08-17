import 'package:before_sunrise/import.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MainApp()));
}

class MainApp extends StatefulWidget {
  MainApp();

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  LocalizableDelegate _localizableDelegate;
  void initState() {
    super.initState();
    _localizableDelegate = LocalizableDelegate(newLocale: null);
    localizableManager.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _localizableDelegate = LocalizableDelegate(newLocale: locale);
    });
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc.instance()),
        ChangeNotifierProvider<ProfileBloc>.value(
            value: ProfileBloc.instance()),
        ChangeNotifierProvider<PostBloc>.value(value: PostBloc.instance()),
        ChangeNotifierProvider<CategoryBloc>.value(
            value: CategoryBloc.instance()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Before Sunrise',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: MainTheme.bgndColor,
          accentColor: MainTheme.activeIndicatorColor,
        ),
        home: new DynamicInitialPage(),
        localizationsDelegates: [
          _localizableDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: localizableManager.supportedLocales(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/category-form': (BuildContext context) => CategoryForm(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');

          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'post') {
            final String _postID = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<PostBloc>(
                builder:
                    (BuildContext context, PostBloc postBloc, Widget child) {
                  final Post _post = postBloc.posts
                      .firstWhere((Post post) => post.postID == _postID);

                  return PostDetails(post: _post);
                },
              );
            });
          }

          if (pathElements[1] == 'like') {
            final String _postID = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<PostBloc>(
                builder:
                    (BuildContext context, PostBloc postBloc, Widget child) {
                  final Post _likedpost = postBloc.likedPosts
                      .firstWhere((Post post) => post.postID == _postID);

                  return PostDetails(post: _likedpost);
                },
              );
            });
          }

          // get the details of selected profile post in profile posts
          if (pathElements[1] == 'profile-post') {
            final String _postID = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<PostBloc>(
                builder:
                    (BuildContext context, PostBloc postBloc, Widget child) {
                  final Post _post = postBloc.profilePosts
                      .firstWhere((Post post) => post.postID == _postID);

                  return PostDetails(post: _post);
                },
              );
            });
          }

          // get details of subscribed post from subscribedPosts
          if (pathElements[1] == 'subscribed-post') {
            final String _postID = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<ProfileBloc>(
                builder: (BuildContext context, ProfileBloc profileBloc,
                    Widget child) {
                  final Post _post = ProfileBloc.latestProfileSubscriptionPosts
                      .firstWhere((Post post) => post.postID == _postID);

                  return PostDetails(post: _post);
                },
              );
            });
          }

          // get the profile of selected post in feed
          if (pathElements[1] == 'post-profile') {
            final String _postID = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<PostBloc>(
                builder:
                    (BuildContext context, PostBloc postBloc, Widget child) {
                  final Post _post = postBloc.posts
                      .firstWhere((Post post) => post.postID == _postID);

                  return ProfilePage(userProfile: _post.profile);
                  // return ProfilePage(post: _post);
                },
              );
            });
          }

          // get the profile of selected post in liked posts
          if (pathElements[1] == 'liked-post-profile') {
            final String _postID = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<PostBloc>(
                builder:
                    (BuildContext context, PostBloc postBloc, Widget child) {
                  final Post _post = postBloc.likedPosts
                      .firstWhere((Post post) => post.postID == _postID);

                  return ProfilePage(userProfile: _post.profile);
                },
              );
            });
          }

          // get the profile of selected post in subscribed posts
          if (pathElements[1] == 'subscribed-post-profile') {
            final String _postID = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<ProfileBloc>(
                builder: (BuildContext context, ProfileBloc profileBloc,
                    Widget child) {
                  final Post _post = ProfileBloc.latestProfileSubscriptionPosts
                      .firstWhere((Post post) => post.postID == _postID);

                  return ProfilePage(userProfile: _post.profile);
                },
              );
            });
          }

          // get the profile of selected subscription in user profile
          if (pathElements[1] == 'subscribed-profile') {
            final String _profileId = pathElements[2];

            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<ProfileBloc>(
                builder: (BuildContext context, ProfileBloc profileBloc,
                    Widget child) {
                  final Profile _userProfile = profileBloc.profileSubscriptions
                      .firstWhere(
                          (Profile profile) => profile.userID == _profileId);

                  return ProfilePage(userProfile: _userProfile);
                },
              );
            });
          }

          // get the profile of current user
          if (pathElements[1] == 'user-profile') {
            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<ProfileBloc>(
                builder: (BuildContext context, ProfileBloc profileBloc,
                    Widget child) {
                  final Profile _userProfile = profileBloc.userProfile;

                  return ProfilePage(userProfile: _userProfile);
                },
              );
            });
          }

          if (pathElements[1] == 'post_form') {
            return MaterialPageRoute(builder: (BuildContext context) {
              return Consumer<ProfileBloc>(
                builder: (BuildContext context, ProfileBloc profileBloc,
                    Widget child) {
                  final Profile _userProfile = profileBloc.userProfile;

                  return PostForm(userProfile: _userProfile);
                },
              );
            });
          }

          return null;
        },
      ),
    );
  }
}

class DynamicInitialPage extends StatefulWidget {
  @override
  _DynamicInitialPageState createState() => _DynamicInitialPageState();
}

class _DynamicInitialPageState extends State<DynamicInitialPage> {
  bool _hasProfile;

  Future<void> _getHasProfile({@required ProfileBloc profileBloc}) async {
    final bool hasProfile = await profileBloc.hasProfile;
    if (_hasProfile == hasProfile) {
      return;
    }

    setState(() {
      _hasProfile = hasProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    final ProfileBloc _profileBloc = Provider.of<ProfileBloc>(context);

    return Consumer<AuthBloc>(
      builder: (BuildContext context, AuthBloc authBloc, Widget child) {
        switch (authBloc.authState) {
          case AuthState.Uninitialized:
            return SplashPage();
          case AuthState.Authenticating:
          case AuthState.Authenticated:
            _getHasProfile(profileBloc: _profileBloc);
            // _loadFollowingProfileLatestPosts();
            if (_hasProfile == null) {
              return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(child: CircularProgressIndicator()));
            }

            if (_hasProfile == false) {
              print("goto ProfileForm");
              return ProfileForm();
            }

            if (_profileBloc.userProfileState == ProfileState.Success) {
              print("goto HomePage");
              return HomePage();
            }

            _profileBloc.fetchUserProfile(); // fetch user profile
            print("fetched profile goto HomePage");
            return HomePage();

          case AuthState.Unauthenticated:
            return AuthPage();
          // return IntroPage();
        }
      },
    );
  }
}

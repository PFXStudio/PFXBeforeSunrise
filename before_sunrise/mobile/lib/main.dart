import 'package:before_sunrise/import.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  // debugPaintSizeEnabled = true;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp();

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Before Sunrise',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: MainTheme.bgndColor,
        accentColor: MainTheme.activeIndicatorColor,
      ),
      // TODO : SplashScreen 에서 로그인 상태 > 프로필 상태 값 보고 다음 페이지 결정
      home: new AuthScreen(),
      localizationsDelegates: [
        _localizableDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: localizableManager.supportedLocales(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        AuthScreen.routeName: (context) => AuthScreen(),
        ProfileInputPage.routeName: (context) {
          var value = ModalRoute.of(context).settings.arguments;
          return ProfileInputPage(value);
        },
        PostFormScreen.routeName: (context) {
          var value = ModalRoute.of(context).settings.arguments;
          return PostFormScreen(category: value);
        },
        PostDetailScreen.routeName: (context) {
          var post = ModalRoute.of(context).settings.arguments;
          return PostDetailScreen(
            post: post,
          );
        },
        ProfileScreen.routeName: (context) {
          Profile profile = ModalRoute.of(context).settings.arguments;
          return ProfileScreen(
            profile: profile,
          );
        },
        TogetherStepForm.routeName: (context) => TogetherStepForm(),
      },
    );
  }
}

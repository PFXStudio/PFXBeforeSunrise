import 'package:before_sunrise/import.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  BlocSupervisor.delegate = SimpleBlocDelegate();
  Injector.configure(Flavor.FIREBASE);

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
      home: new AuthPage(),
      localizationsDelegates: [
        _localizableDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: localizableManager.supportedLocales(),
      routes: {
        AuthPage.routeName: (context) => AuthPage(),
        ProfileInputPage.routeName: (context) => ProfileInputPage(),
      },
    );
  }
}

import 'package:before_sunrise/import.dart';

class LocalizableLoader {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  LocalizableLoader(Locale locale) {
    this.locale = locale;
  }

  static LocalizableLoader of(BuildContext context) {
    return Localizations.of<LocalizableLoader>(context, LocalizableLoader);
  }

  static Future<LocalizableLoader> load(Locale locale) async {
    LocalizableLoader localizableLoader = LocalizableLoader(locale);
    String path = "assets/localizables/${locale.languageCode}.json";
    String jsonContent = await rootBundle.loadString(path);
    _localisedValues = json.decode(jsonContent);
    return localizableLoader;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues[key] ?? "null";
  }
}

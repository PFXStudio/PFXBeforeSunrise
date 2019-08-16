import 'package:before_sunrise/import.dart';

class LocalizableDelegate extends LocalizationsDelegate<LocalizableLoader> {
  final Locale newLocale;

  const LocalizableDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return localizableManager.supportedLanguagesCodes
        .contains(locale.languageCode);
  }

  @override
  Future<LocalizableLoader> load(Locale locale) {
    return LocalizableLoader.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocalizableLoader> old) {
    return true;
  }
}

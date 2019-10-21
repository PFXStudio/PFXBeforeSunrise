import 'dart:ui';

class LocalizableManager {
  static final LocalizableManager _localizableManager =
      LocalizableManager._internal();

  factory LocalizableManager() {
    return _localizableManager;
  }

  LocalizableManager._internal();

  final List<String> supportedLanguages = [
    "English",
    "Korean",
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "kr",
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

LocalizableManager localizableManager = LocalizableManager();
typedef void LocaleChangeCallback(Locale locale);

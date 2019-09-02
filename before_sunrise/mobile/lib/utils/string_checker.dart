import 'package:http/http.dart' as http;

class StringChecker {
  static bool validUrl(String url) {
    var urlPattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var match = new RegExp(urlPattern, caseSensitive: false).firstMatch(url);
    if (match == null) {
      return false;
    }

    return true;
  }
}

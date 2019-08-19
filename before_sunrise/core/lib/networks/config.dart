import 'dart:typed_data';

class Config {
  Config._internal();
  static final Config _instance = new Config._internal();

  factory Config() {
    return _instance;
  }

  String root() {
    bool inDebugMode = false;
    assert(inDebugMode = true);

    if (inDebugMode == true) {
      return "dev";
    }

    return "real";
  }
}

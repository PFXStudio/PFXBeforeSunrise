import 'package:before_sunrise/import.dart';

class BeforeSunrise {
  static bool get checkDebugBool {
    var debug = false;
    assert(debug = true);

    return debug;
  }

  static bool isAdminPhoneNumber(String phoneNumber) {
    if (phoneNumber == "+821098460071") {
      return true;
    }

    if (phoneNumber == "+821055555555") {
      return true;
    }

    if (phoneNumber == "+821066666666") {
      return true;
    }

    return false;
  }

  static bool isBlockPhoneNumber(String phoneNumber) {
    if (phoneNumber == "+821087978791") {
      return true;
    }

    if (phoneNumber == "+821028876798") {
      return true;
    }

    if (phoneNumber == "+821020759729") {
      return true;
    }

    if (phoneNumber == "+821036637988") {
      return true;
    }

    return false;
  }
}

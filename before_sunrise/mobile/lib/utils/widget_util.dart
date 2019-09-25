import 'package:flutter/widgets.dart';
import 'package:before_sunrise/import.dart';

double kDeviceWidth = 0;
double kDeviceHeight = 0;
void addIfNonNull(Widget widget, List<Widget> children) {
  if (widget != null) {
    children.add(widget);
  }
}

void initializeDeviceSize(BuildContext context) {
  kDeviceWidth = MediaQuery.of(context).size.width;
  kDeviceHeight = MediaQuery.of(context).size.height;
}

String categoryName(String index) {
  if (index == "0") {
    return "/free/posts";
  }

  if (index == "1") {
    return "/realtime/posts";
  }

  return "";
}

String getPostType(String category) {
  if (category == "/free/posts") {
    return "Free";
  }

  if (category == "/realtime/posts") {
    return "RealTime";
  }

  return "Free";
}

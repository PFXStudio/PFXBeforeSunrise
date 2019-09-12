import 'package:flutter/widgets.dart';

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

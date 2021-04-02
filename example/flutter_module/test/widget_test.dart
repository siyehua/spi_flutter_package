// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:spi_flutter_package/spi_flutter_package.dart';

void main() {
  String flutterPath = "./lib/channel";
  String packageName = "com.siyehua.spiexample.channel";
  String androidSavePath = "../app/src/main/java";
  spi_flutter_package_start(flutterPath, packageName, androidSavePath);
}
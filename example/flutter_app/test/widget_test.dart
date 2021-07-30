// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:spi_flutter_package/spi_flutter_package.dart';

void main() async {
  String flutterPath = "./lib/channel"; //需要转换的 dart 目录
  String packageName = "com.siyehua.spiexample.channel"; //java 包名
  String androidSavePath = "./android/app/src/main/kotlin"; //需要保存的 java 路径
  String iosPrefix = "MQQFlutterGen_";
  String iosSavePath = "./ios/Classes";
  await spiFlutterPackageStart(
      flutterPath, packageName, androidSavePath, iosPrefix, iosSavePath,
      nullSafe: true);
}
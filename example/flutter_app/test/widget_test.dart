// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:spi_flutter_package/file_config.dart';
import 'package:spi_flutter_package/spi_flutter_package.dart';

void main() async {
  await spiFlutterPackageStart([
    FlutterPlatformConfig()
      ..sourceCodePath = "./lib/channel" //flutter source code
      ..channelName = "com.siyehua.spiexample.channel" //channel name
    ,
    AndroidPlatformConfig()
      ..savePath = "./android/app/src/main/kotlin" //android save path
      ..channelName = "com.siyehua.spiexample.channel"
    ,
    IosPlatformConfig()
      ..iosProjectPrefix = "MQQFlutterGen_" //iOS pre
      ..savePath = "./ios/Classes" //iOS save path
    ,
  ], nullSafe: true);
}

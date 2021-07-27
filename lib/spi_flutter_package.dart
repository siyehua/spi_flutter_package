import 'flutter2native_parse.dart';
import 'manager/manager_creater.dart';
import 'native2flutter_parse.dart';

// void main() async {
//   String flutterPath = "./lib/example";
//   String packageName = "com.siyehua.platforms_channel_plugin.channel";
//   String androidSavePath = "./android/src/main/kotlin";
//   await spiFlutterPackageStart(flutterPath, packageName, androidSavePath, nullSafe: false);
// }

/// [nullSafe] support null safe
/// [androidCustomDoc] it will add it ChannelManager file in android's file.
Future<void> spiFlutterPackageStart(
  String flutterPath,
  String packageName,
  String androidSavePath, {
  bool nullSafe = true,
  String androidCustomDoc = "",
  String flutterCustomDoc = "",
}) async {
  await flutter2Native(flutterPath, packageName, androidSavePath, nullSafe);
  await native2flutter(flutterPath, packageName, androidSavePath, nullSafe);
  ManagerUtils.gentManager(flutterPath, packageName, androidSavePath,
      androidCustomDoc: androidCustomDoc, nullSafeSupport: nullSafe);
}

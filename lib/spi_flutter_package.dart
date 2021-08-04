export 'file_config.dart';

import 'file_config.dart';
import 'flutter2native_parse.dart';
import 'manager/manager_creater.dart';
import 'native2flutter_parse.dart';

// void main() async {
//   String flutterPath = "./lib/example";
//   String packageName = "com.siyehua.platforms_channel_plugin.channel";
//   String androidSavePath = "./android/src/main/kotlin";
//   await spiFlutterPackageStart(flutterPath, packageName, androidSavePath, nullSafe: false);
// }

Future<void> spiFlutterPackageStart(
  List<PlatformConfig> platformConfigs, {
  bool nullSafe = true,
}) async {
  FlutterPlatformConfig flutterConfig = platformConfigs
      .where((element) => element is FlutterPlatformConfig)
      .first as FlutterPlatformConfig;

  AndroidPlatformConfig? androidConfig;
  platformConfigs
      .where((element) => element is AndroidPlatformConfig)
      .forEach((element) {
    androidConfig = element as AndroidPlatformConfig;
  });
  if (androidConfig != null) {
    assert(
        androidConfig!.savePath.isNotEmpty, "you should set android save path");
    if (androidConfig!.channelName.isEmpty) {
      androidConfig!.channelName = flutterConfig.channelName;
    }
    if (androidConfig!.packageName.isEmpty) {
      androidConfig!.packageName = flutterConfig.channelName;
    }
  }

  IosPlatformConfig? iosConfig;
  platformConfigs
      .where((element) => element is IosPlatformConfig)
      .forEach((element) {
    iosConfig = element as IosPlatformConfig;
  });
  if (iosConfig != null) {
    assert(iosConfig!.savePath.isNotEmpty, "you should set ios save path");
    assert(iosConfig!.iosProjectPrefix.isNotEmpty,
        "you should set ios iosProjectPrefix");
    if (iosConfig!.channelName.isEmpty) {
      iosConfig!.channelName = flutterConfig.channelName;
    }
  }

  await flutter2Native(flutterConfig, nullSafe,
      androidConfig: androidConfig, iosConfig: iosConfig);
  await native2flutter(flutterConfig, nullSafe,
      androidConfig: androidConfig, iosConfig: iosConfig);
  await ManagerUtils.gentManager(flutterConfig, nullSafe,
      androidConfig: androidConfig, iosConfig: iosConfig);
}

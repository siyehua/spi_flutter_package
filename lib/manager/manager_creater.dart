import 'dart:io';

import 'package:platforms_source_gen/gen_file_edit.dart';
import 'package:spi_flutter_package/flutter2native_parse.dart';

import '../file_config.dart';
import 'dart_channel_manager.dart';
import 'java_channel_manager.dart';
import 'objc_channel_manager.dart';

class ManagerInfo {
  String key() => savePath + channelName;

  String savePath = "";
  String channelName = "";

  //android
  String javaManagerImport = "";
  String javaImplStr = "";
  String packageName = "";
}

class ManagerUtils {
  static Map<String, ManagerInfo> managerInfo = {};
  static String dartManagerImport = "import 'package:flutter/services.dart';\n";
  static String dartImplStr = "";

  static Future<void> gentManager(
    FlutterPlatformConfig flutterConfig,
    bool nullSafeSupport, {
    AndroidPlatformConfig? androidConfig,
    IosPlatformConfig? iosConfig,
  }) async {
    {
      //create flutter manager, the manager has only one file
      String flutterSavePath =
          flutterConfig.sourceCodePath + "/generated/channel";
      String channelStr = "";
      managerInfo.forEach((key, info) {
        if (!channelStr.contains(info.channelName)) {
          //    _packages.add('com.siyehua.example.otherChannelName');
          channelStr += "\t\t_packages.add('${info.channelName}');\n";
        }
      });
      String newContent = dartStr
          .replaceAll("import 'package:flutter/services.dart';", dartManagerImport)
          .replaceAll("custom doc should replace", flutterConfig.customDoc)
          .replaceAll("//_packages.add", channelStr)
          .replaceAll("//replace", dartImplStr);
      newContent = "\nimport 'dart:typed_data';\n" + newContent;
      Directory dir = Directory(flutterSavePath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      File file = File(flutterSavePath + "/channel_manager.dart");
      if (!nullSafeSupport) {
        newContent = GenFileEdit.removeDartNullSafe(newContent);
      }
      file.writeAsStringSync(newContent);
    }

    //create android manager
    if (androidConfig != null) {
      // File file2 = File("./tool/ChannelManager_java");
      managerInfo.forEach((key, info) {
        String newContent2 = javaStr
            .replaceAll("package tool", "package ${info.packageName}")
            .replaceAll("custom doc should replace", androidConfig.customDoc)
            .replaceAll(
                "import java.lang.reflect.Type;", info.javaManagerImport)
            .replaceAll(
                "//generated add native2flutter impl in this", info.javaImplStr)
            .replaceAll("private static final String channelName = \"123456\";",
                "private static final String channelName = \"${info.channelName}\";");

        File androidFile = File(info.savePath +
            "/" +
            info.packageName.replaceAll(".", "/") +
            "/ChannelManager.java");
        androidFile.createSync(recursive: true);
        if (!nullSafeSupport) {
          newContent2 = GenFileEdit.removeJavaNullSafe(newContent2);
        }
        androidFile.writeAsStringSync(newContent2);
      });
    }

    // create ios manager
    if (iosConfig != null) {
      String objcHeaderString = objcChannelInterfaceString.replaceAll(
          "#{projectPrefix}", iosConfig.iosProjectPrefix);
      String objcImplementationString = objcChannelImplementationString
          .replaceAll("#{projectPrefix}", iosConfig.iosProjectPrefix)
          .replaceAll("com.example.channelname", iosConfig.channelName);
      File objcHeaderFile = File(iosConfig.savePath +
          "/Manager/${iosConfig.iosProjectPrefix}ChannelManager.h");
      File objcImplementFile = File(iosConfig.savePath +
          "/Manager/${iosConfig.iosProjectPrefix}ChannelManager.m");
      objcHeaderFile.createSync(recursive: true);
      objcHeaderFile.writeAsStringSync(objcHeaderString);
      objcImplementFile.createSync(recursive: true);
      objcImplementFile.writeAsStringSync(objcImplementationString);
    }
  }
}

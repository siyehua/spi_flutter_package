import 'dart:io';

import 'package:platforms_source_gen/gen_file_edit.dart';

import '../file_config.dart';
import 'dart_channel_manager.dart';
import 'java_channel_manager.dart';
import 'objc_channel_manager.dart';

class JavaInfo {
  String javaManagerImport = "";
  String javaImplStr = "";
  String channelName = "";

  JavaInfo();

  JavaInfo.create({
    this.javaManagerImport = "",
    this.javaImplStr = "",
    this.channelName = "",
  });
}

class ManagerUtils {
  static String dartManagerImport = "import 'package:flutter/services.dart';\n";
  static String dartImplStr = "";

  static Map<String, List<JavaInfo>> javaSaveList = {};

  static Future<void> gentManager(
    FlutterPlatformConfig flutterConfig,
    bool nullSafeSupport, {
    AndroidPlatformConfig? androidConfig,
    IosPlatformConfig? iosConfig,
  }) async {
    //create flutter manager
    {
      String flutterSavePath =
          flutterConfig.sourceCodePath + "/generated/channel";
      // File file = File("./tool/ChannelManager_dart");
      String newContent = dartStr
          .replaceAll("import 'package:flutter/services.dart';",
              ManagerUtils.dartManagerImport)
          .replaceAll("custom doc should replace", flutterConfig.customDoc)
          .replaceAll("static const _package = \"123567\";",
              "static const _package = \"${flutterConfig.channelName}\";")
          .replaceAll("//replace", ManagerUtils.dartImplStr);
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
      androidConfig.savePath +=
          "/" + androidConfig.channelName.replaceAll(".", "/");
      if (!javaSaveList.containsKey(androidConfig.savePath)) {
        javaSaveList[androidConfig.savePath] = [];
      }
      // print("java savepath: $javaSaveList");
      javaSaveList.forEach((filePath, value) {
        String importStr = "";
        String javaImplStr = "";
        String channelName = androidConfig.channelName;
        value.forEach((element) {
          if (element.channelName.isNotEmpty) {
            channelName = element.channelName;
          }
          importStr += element.javaManagerImport;
          javaImplStr += element.javaImplStr;
        });
        String newContent2 = javaStr
            .replaceAll("package tool", "package ${androidConfig.packageName}")
            .replaceAll("custom doc should replace", androidConfig.customDoc)
            .replaceAll("import java.lang.reflect.Type;", importStr)
            .replaceAll(
                "//generated add native2flutter impl in this", javaImplStr)
            .replaceAll("private static final String channelName = \"123456\";",
                "private static final String channelName = \"$channelName\";");

        File androidFile = File(filePath + "/ChannelManager.java");
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

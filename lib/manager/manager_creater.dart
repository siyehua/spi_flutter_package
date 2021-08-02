import 'dart:io';

import 'package:platforms_source_gen/gen_file_edit.dart';

import 'dart_channel_manager.dart';
import 'java_channel_manager.dart';
import 'objc_channel_manager.dart';

class ManagerUtils {
  static String dartManagerImport = "import 'package:flutter/services.dart';\n";
  static String dartImplStr = "";

  static String javaManagerImport = "";
  static String javaImplStr = "";

  static void gentManager(
    String flutterPath,
    String packageName,
    String androidSavePath,
    String projectPrefix,
    String iosSavePath, {
    String androidCustomDoc = "",
    String flutterCustomDoc = "",
    bool nullSafeSupport = true,
  }) {
    //create flutter manager
    {
      String flutterSavePath = flutterPath + "/generated/channel";
      // File file = File("./tool/ChannelManager_dart");
      String newContent = dartStr
          .replaceAll("import 'package:flutter/services.dart';",
              ManagerUtils.dartManagerImport)
          .replaceAll("custom doc should replace", flutterCustomDoc)
          .replaceAll("static const _package = \"123567\";",
              "static const _package = \"$packageName\";")
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
    {
      // File file2 = File("./tool/ChannelManager_java");
      String newContent2 = javaStr
          .replaceAll("package tool",
              "package " + packageName.replaceAll(".flutter2native", ""))
          .replaceAll("custom doc should replace", androidCustomDoc)
          .replaceAll(
              "import java.lang.reflect.Type;", ManagerUtils.javaManagerImport)
          .replaceAll("//generated add native2flutter impl in this",
              ManagerUtils.javaImplStr)
          .replaceAll("private static final String channelName = \"123456\";",
              "private static final String channelName = \"$packageName\";");
      androidSavePath += "/" + packageName.replaceAll(".", "/");
      File androidFile = File(androidSavePath + "/ChannelManager.java");
      androidFile.createSync(recursive: true);
      if (!nullSafeSupport) {
        newContent2 = GenFileEdit.removeJavaNullSafe(newContent2);
      }
      androidFile.writeAsStringSync(newContent2);
    }

    // create ios manager
    {
      String objcHeaderString = objcChannelInterfaceString.replaceAll(
          "#{projectPrefix}", projectPrefix);
      String objcImplementationString = objcChannelImplementationString
          .replaceAll("#{projectPrefix}", projectPrefix)
          .replaceAll("com.example.channelname", packageName);
      File objcHeaderFile =
          File(iosSavePath + "/Manager/${projectPrefix}ChannelManager.h");
      File objcImplementFile =
          File(iosSavePath + "/Manager/${projectPrefix}ChannelManager.m");
      objcHeaderFile.createSync(recursive: true);
      objcHeaderFile.writeAsStringSync(objcHeaderString);
      objcImplementFile.createSync(recursive: true);
      objcImplementFile.writeAsStringSync(objcImplementationString);
    }
  }
}

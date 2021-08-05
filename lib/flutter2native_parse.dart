import 'dart:io';

import 'package:platforms_source_gen/gen_file_edit.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';
import 'package:platforms_source_gen/type_utils.dart';

import 'auto_gen_class_json.dart';
import 'file_config.dart';
import 'manager/manager_creater.dart';
import 'utils/flutter_file_utils.dart';
import 'utils/android_file_utils.dart';
import 'utils/ios_file_utils.dart';

class Flutter2Native {
  static final List<FileConfig> fileConfigs = [];
}

Future<void> flutter2Native(
  FlutterPlatformConfig flutterConfig,
  bool nullSafeSupport, {
  AndroidPlatformConfig? androidConfig,
  IosPlatformConfig? iosConfig,
}) async {
  Directory directory =
      Directory(flutterConfig.sourceCodePath + "/flutter2native");
  if (!directory.existsSync()) {
    return;
  }
  List<GenClassBean> list = await platforms_source_gen_init(
      flutterConfig.sourceCodePath + "/flutter2native");

  await autoCreateJsonParse(list, directory.path, nullSafeSupport);
  list.forEach((element) {
    element.methods.removeWhere((element) => element.name == "toJson");
  });
  list.forEach((element) {
    var fileConfig = FileConfig.copy(flutterConfig, androidConfig, iosConfig);
    //set custom save path
    String classPath = element.path.split(":")[1];
    classPath = "./lib" + classPath.substring(classPath.indexOf("/"));
    Map<int, String> lines = File(classPath).readAsLinesSync().asMap();
    for (int index in lines.keys) {
      if (index == 0) {
        if (lines[index]?.contains("FileConfig") != true) {
          Flutter2Native.fileConfigs.add(fileConfig);
          break;
        }
      } else if (lines[index]?.startsWith("//") == true) {
        if (lines[index]?.contains("androidSavePath") == true) {
          String savePath = lines[index]?.split("=")[1].trim() ?? "";
          fileConfig.flutterPlatformConfig.savePath = savePath;
          fileConfig.androidPlatformConfig?.savePath = savePath;
          // fileConfig.iosPlatformConfig?.savePath = savePath;
        } else if (lines[index]?.contains("channelName") == true) {
          String channelName = lines[index]?.split("=")[1].trim() ?? "";
          fileConfig.flutterPlatformConfig.channelName = channelName;
          fileConfig.androidPlatformConfig?.channelName = channelName;
          // fileConfig.iosPlatformConfig?.channelName = channelName;
        } else if (lines[index]?.contains("packageName") == true) {
          String packageName = lines[index]?.split("=")[1].trim() ?? "";
          fileConfig.androidPlatformConfig?.packageName = packageName;
        }
      } else {
        Flutter2Native.fileConfigs.add(fileConfig);
        break;
      }
    }
  });

  Flutter2Native.fileConfigs.asMap().forEach((index, config) {
    //if not set packageName, the packageName = channelName
    String packageName = config.flutterPlatformConfig.channelName;
    if (config.androidPlatformConfig?.packageName.isNotEmpty == true) {
      packageName = config.androidPlatformConfig!.packageName;
    }
    _genFlutterImpl(
      [list[index]],
      config.flutterPlatformConfig.sourceCodePath,
      packageName,
      config.flutterPlatformConfig.channelName,
      nullSafeSupport,
    );

    ////////////////////////android//////////////////////////
    ////////////////////////android//////////////////////////
    ////////////////////////android//////////////////////////
    if (androidConfig != null) {
      JavaFileUtils.genJavaCode(
          [list[index]],
          config.androidPlatformConfig!.packageName,
          config.androidPlatformConfig!.savePath,
          ".flutter2native",
          nullSafeSupport: nullSafeSupport);
    }
  });

  ////////////////////////ios//////////////////////////
  ////////////////////////ios//////////////////////////
  ////////////////////////ios//////////////////////////
  if (iosConfig != null) {
    ObjcFileUtils.genObjcCode(
        list, iosConfig.iosProjectPrefix, iosConfig.savePath, ".flutter2native",
        nullSafeSupport: nullSafeSupport);
  }
}

void _genFlutterImpl(
  List<GenClassBean> list,
  String flutterPath,
  String packageName,
  String channelName,
  bool nullSafeSupport,
) {
  String flutterSavePath = flutterPath + "/generated/channel";
  flutterPath += "/flutter2native";
  packageName += ".flutter2native";

  list
      .where((classBean) =>
          classBean.classInfo.type == 1 &&
          File(classBean.path).parent.path != flutterSavePath)
      .forEach((classBean) {
    //impl interface
    String methodStr = "";
    classBean.methods.forEach((method) {
      List<String> arguments = [];
      List<String> argumentsName = [];
      String argsStr = "";
      method.args.forEach((arg) {
        argumentsName.add(arg.name);
        arguments.add(FlutterFileUtils.parseMethodArgs(arg));
        argsStr += "${FlutterFileUtils.getTypeStr(arg)} ${arg.name}, ";
      });

      String returnTypeStr = "void";
      if (method.returnType.type != "void") {
        returnTypeStr = FlutterFileUtils.getTypeStr(method.returnType);
      }

      String returnStr = "";
      String exp = "";
      if (method.returnType.type != "void") {
        //	Type clsType = IShare;
        // 		List<dynamic> a = await ChannelManager.invoke(package, clsType.toString(), "getFeedList", []);
        // 		List<String> b = a.map((e) => e as String).toList();
        // 		return b;
        // Type clsType = IAccount;
        //     Map<dynamic, dynamic> a = await ChannelManager.invoke(package, clsType.toString(), "a22222222",);
        //     Map<String, bool> b = a.map((key, value) => MapEntry(key as String, value as bool));
        //     return b;
        if (TypeUtils.isListType(method.returnType.subType[0])) {
          //list
          returnStr = "dynamic result = await ";
          String type =
              FlutterFileUtils.getTypeStr(method.returnType.subType[0]);
          exp =
              "\t\t$type _b = ${FlutterFileUtils.createParseCode(method.returnType.subType[0])};\n\t\treturn _b;\n";
        } else if (TypeUtils.isMapType(method.returnType.subType[0])) {
          returnStr = "dynamic result = await ";
          String type =
              FlutterFileUtils.getTypeStr(method.returnType.subType[0]);
          exp =
              "\t\t$type _b = ${FlutterFileUtils.createParseCode(method.returnType.subType[0])};\n\t\treturn _b;\n";
        } else if (!TypeUtils.isBaseType(method.returnType.subType[0])) {
          returnStr = "dynamic result = await ";
          String type =
              FlutterFileUtils.getTypeStr(method.returnType.subType[0]);
          exp =
              "\t\t$type _b = ${FlutterFileUtils.createParseCode(method.returnType.subType[0])};\n\t\treturn _b;\n";
        } else {
          returnStr = "return await ";
        }
        argumentsName.add("callback");
      }

      String argNames = argumentsName
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "")
          .replaceAll(" ", "");
      String methodContent = "\t\tType _clsType = ${classBean.classInfo.name};\n" +
          "\t\t$returnStr ChannelManager.invoke('$channelName', package, _clsType.toString(), \"${method.name}\", \"$argNames\", ${arguments.isEmpty ? "" : arguments.toString()});\n" +
          exp;

      methodStr += "\t@override\n" +
          "\t$returnTypeStr ${method.name}($argsStr) async{\n" +
          methodContent +
          "\t}\n";
    });
    String classPath = classBean.path.split("/").last;
    String filePreName =
        classBean.classInfo.name.replaceAllMapped(RegExp("[A-Z]"), (match) {
      // print("${match.input} + match:${ match.group(0)}");
      return "_" + match.group(0)!.toLowerCase();
    });
    // print(filePreName);
    if (filePreName.startsWith("_")) {
      filePreName = filePreName.replaceFirst("_", "");
    }
    classPath = classPath.substring(0, classPath.indexOf(".dart:") + 5);
    ManagerUtils.dartManagerImport +=
        "import '../../flutter2native/$classPath';\n" +
            "import 'impl/${filePreName}_impl.dart';\n";
    ManagerUtils.dartImplStr +=
        "\t\tadd(${classBean.classInfo.name}, ${classBean.classInfo.name}Impl());\n";
    String importStr = "import '../channel_manager.dart';\n" +
        "import '../../../flutter2native/$classPath';\n" +
        "import 'dart:convert';\n" +
        "import 'dart:typed_data';\n";
    String allContent = importStr +
        "class ${classBean.classInfo.name}Impl  implements ${classBean.classInfo.name}, PackageTag{\n" +
        methodStr +
        "\t@override\n\tString package = \"$packageName\";\n" +
        "}\n";
    if (!nullSafeSupport) {
      allContent = GenFileEdit.removeDartNullSafe(allContent);
    }
    Directory dir = Directory(flutterSavePath + "/impl");
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    File impFile = File(dir.path + "/${filePreName}_impl.dart");
    impFile.writeAsStringSync(allContent);
  });
}

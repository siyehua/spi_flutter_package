import 'dart:io';

import 'package:platforms_source_gen/gen_file_edit.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';
import 'package:platforms_source_gen/type_utils.dart';

import 'auto_gen_class_json.dart';
import 'manager/manager_creater.dart';
import 'utils/flutter_file_utils.dart';
import 'utils/android_file_utils.dart';
import 'utils/ios_file_utils.dart';

Future<void> flutter2Native(
  String flutterPath,
  String packageName,
  String androidSavePath,
  String iosProjectPrefix,
  String iosSavePath,
  bool nullSafeSupport,
) async {
  Directory directory = Directory(flutterPath + "/flutter2native");
  if (!directory.existsSync()) {
    return;
  }
  List<GenClassBean> list = await platforms_source_gen_init(
      flutterPath + "/flutter2native", //you dart file path
      packageName + ".flutter2native", //your android's  java class package name
      androidSavePath +
          "/" +
          packageName.replaceAll(".", "/") //your android file save path
      );
  await autoCreateJsonParse(list, directory.path, nullSafeSupport);
  list.forEach((element) {
    element.methods.removeWhere((element) => element.name == "toJson");
  });

  _genFlutterImpl(flutterPath, packageName, list, nullSafeSupport);

  ////////////////////////android//////////////////////////
  ////////////////////////android//////////////////////////
  ////////////////////////android//////////////////////////
  JavaFileUtils.genJavaCode(
      list, packageName, androidSavePath, ".flutter2native",
      nullSafeSupport: nullSafeSupport);

  ////////////////////////ios//////////////////////////
  ////////////////////////ios//////////////////////////
  ////////////////////////ios//////////////////////////
  ObjcFileUtils.genObjcCode(
      list, iosProjectPrefix, iosSavePath, ".flutter2native",
      nullSafeSupport: nullSafeSupport);
}

void _genFlutterImpl(
  String flutterPath,
  String packageName,
  List<GenClassBean> list,
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
      List<String> argNames = [];
      String argsStr = "";
      method.args.forEach((arg) {
        argNames.add(FlutterFileUtils.parseMethodArgs(arg));
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
      }

      String methodContent = "\t\tType _clsType = ${classBean.classInfo.name};\n" +
          "\t\t$returnStr ChannelManager.invoke(package, _clsType.toString(), \"${method.name}\", ${argNames.isEmpty ? "" : argNames.toString()});\n" +
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
    print(filePreName);
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

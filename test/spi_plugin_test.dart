import 'dart:io';

import 'package:platforms_source_gen/platforms_source_gen.dart';

void main() {
  String flutterPath = "./lib/example";
  String packageName =
      "com.siyehua.platforms_channel_plugin.channel.flutter2native";
  String savePath =
      "./android/src/main/kotlin" + "/" + packageName.replaceAll(".", "/");
  List<GenClassBean> list = platforms_source_gen_init(
      flutterPath + "/flutter2native", //you dart file path
      packageName, //your android's  java class package name
      savePath //your android file save path
      );
  _genFlutterImpl(flutterPath, packageName, list);

  // list.forEach((classBean) {
  //   int target = classBean.methods.indexWhere((method) {
  //     return method.returnType.type.startsWith("Future<");
  //   });
  //   if (target >= 0) {
  //     String returnType = classBean.methods[target].returnType.type;
  //     String callbackStr =
  //         returnType.replaceAll("Future<", "ChannelManager.Result<").trim();
  //     Property property = Property();
  //     property.type = callbackStr;
  //     property.name = "callback";
  //     property.typeInt = 0;
  //     classBean.methods[target].args.add(property);
  //     classBean.methods[target].returnType.type = "void";
  //   }
  // });
  // platforms_source_gent_start(
  //     packageName, //your android's  java class package name
  //     savePath, //your android file save path
  //     list);
  // File file2 = File("./tool/ChannelManager_java");
  // String newContent2 = file2.readAsStringSync().replaceAll("package tool",
  //     "package " + packageName.replaceAll(".flutter2native", ""));
  // File(savePath + "/../ChannelManager.java").writeAsStringSync(newContent2);
}

_genFlutterImpl(
    String flutterPath, String packageName, List<GenClassBean> list) {
  String flutterSavePath = flutterPath + "/generated/channel";
  flutterPath += "/flutter2native";

  String channelImport = "import 'package:flutter/services.dart';\n";
  String implStr = "";
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
        argNames.add(arg.name);
        argsStr += "${arg.type} ${arg.name}, ";
      });

      String returnStr = "";
      String exp = "";
      if (method.returnType.type != "void") {
        //	Type clsType = IShare;
        // 		List<Object> a = await ChannelManager.invoke(package, clsType.toString(), "getFeedList", []);
        // 		List<String> b = a.map((e) => e as String).toList();
        // 		return b;
        // Type clsType = IAccount;
        //     Map<dynamic, dynamic> a = await ChannelManager.invoke(package, clsType.toString(), "a22222222",);
        //     Map<String, bool> b = a.map((key, value) => MapEntry(key as String, value as bool));
        //     return b;
        RegExp regExp =new RegExp(r"Future<List<\S+>>");
        if(regExp.hasMatch(method.returnType.type)) {
          returnStr = "List<Object> _a = await ";
          String type = method.returnType.type.replaceAll("Future<List<", "").replaceAll(">>", "");
          exp = "\t\tList<$type> _b = _a.map((e) => e as $type).toList();\n\t\treturn _b;\n";
        }else if(new RegExp(r"Future<Map<.*,.*>>").hasMatch(method.returnType.type)){
          returnStr = "Map<dynamic, dynamic> _a = await ";
           List<String> type = method.returnType.type.replaceAll("Future<Map<", "").replaceAll(">>", "").split(",");
          exp = "\t\tMap<${type[0].trim()}, ${type[1].trim()}> _b = _a.map((key, value) => MapEntry(key as ${type[0].trim()}, value as ${type[1].trim()}));\n\t\treturn _b;\n";
        }else{
          returnStr = "return ";
        }
      }

      String methodContent = "\t\tType _clsType = ${classBean.classInfo.name};\n" +
          "\t\t$returnStr ChannelManager.invoke(package, _clsType.toString(), \"${method.name}\", ${argNames.isEmpty ? "" : argNames.toString()});\n"
      + exp;

      methodStr += "\t@override\n" +
          "\t${method.returnType.type} ${method.name}($argsStr) ${exp.isEmpty ? "": "async "}{\n" +
          methodContent +
          "\t}\n";
    });
    channelImport +=
        "import '../../flutter2native/${classBean.path.split("/").last}';\n" +
            "import 'impl/${classBean.classInfo.name.toLowerCase()}_impl.dart';\n";
    implStr +=
        "\t\tadd(${classBean.classInfo.name}, ${classBean.classInfo.name}Impl());\n";
    String importStr = "import '../ChannelManager.dart';\n" +
        "import '../../../flutter2native/${classBean.path.split("/").last}';\n";
    String allContent = importStr +
        "class ${classBean.classInfo.name}Impl  implements ${classBean.classInfo.name}, PackageTag{\n" +
        methodStr +
        "\t@override\n\tString package = \"$packageName\";\n" +
        "}\n";
    Directory dir = Directory(flutterSavePath + "/impl");
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    File impFile =
        File(dir.path + "/${classBean.classInfo.name.toLowerCase()}_impl.dart");
    impFile.writeAsStringSync(allContent);
  });
//import 'flutter2native/example2.dart';
// import 'flutter2native/example2_impl.dart';
  //    add(IAccount, IAccountImpl());
  File file = File("./tool/ChannelManager_dart");
  String newContent = file
      .readAsStringSync()
      .replaceAll("import 'package:flutter/services.dart';", channelImport)
      .replaceAll("//replace", implStr);
  Directory dir = Directory(flutterSavePath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  File(flutterSavePath + "/ChannelManager.dart").writeAsStringSync(newContent);
}

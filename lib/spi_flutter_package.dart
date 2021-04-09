import 'dart:io';

import 'package:platforms_source_gen/platforms_source_gen.dart';
import 'package:platforms_source_gen/property_parse.dart';
import 'package:platforms_source_gen/android_gen.dart';
import './dart_channel_manager.dart';
import './java_channel_manager.dart';

void main() {
  String flutterPath = "./lib/example";
  String packageName = "com.siyehua.platforms_channel_plugin.channel";
  String androidSavePath = "./android/src/main/kotlin";
  spi_flutter_package_start(flutterPath, packageName, androidSavePath);
}

void spi_flutter_package_start(String flutterPath, String packageName,
    String androidSavePath) {
  _flutter2Native(flutterPath, packageName, androidSavePath);
  _native2flutter(flutterPath, packageName, androidSavePath);
  _gentManager(flutterPath, packageName, androidSavePath);
}


void _flutter2Native(String flutterPath, String packageName,
    String androidSavePath) {
  Directory directory = Directory(flutterPath + "/flutter2native");
  if (!directory.existsSync()) {
    return;
  }
  List<GenClassBean> list = platforms_source_gen_init(
      flutterPath + "/flutter2native", //you dart file path
      packageName + ".flutter2native", //your android's  java class package name
      androidSavePath +
          "/" +
          packageName.replaceAll(".", "/") //your android file save path
  );

  _genFlutterImpl(flutterPath, packageName, list);
  _genJavaCode(list, packageName, androidSavePath, ".flutter2native");
}

void _native2flutter(String flutterPath, String packageName,
    String androidSavePath) {
  Directory directory = Directory(flutterPath + "/native2flutter");
  if (!directory.existsSync()) {
    return;
  }
  List<GenClassBean> list = platforms_source_gen_init(
      flutterPath + "/native2flutter", //you dart file path
      packageName + ".native2flutter", //your android's  java class package name
      androidSavePath +
          "/" +
          packageName.replaceAll(".", "/") //your android file save path
  );
  if (list.isEmpty) {
    return;
  }

  _genFlutterParse(flutterPath, packageName, list);
  _genJavaCode(list, packageName, androidSavePath, ".native2flutter");
  _gentJavaImpl(list, packageName, androidSavePath);
}

void _gentManager(String flutterPath, String packageName,
    String androidSavePath) {
  //create flutter manager
  String flutterSavePath = flutterPath + "/generated/channel";
  // File file = File("./tool/ChannelManager_dart");
  String newContent =
  dartStr
      .replaceAll("import 'package:flutter/services.dart';", _channelImport)
      .replaceAll("static const _package = \"123567\";",
      "static const _package = \"${packageName}\";")
      .replaceAll("//replace", _implStr);
  Directory dir = Directory(flutterSavePath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  File(flutterSavePath + "/ChannelManager.dart").writeAsStringSync(newContent);

  //create android manager
  // File file2 = File("./tool/ChannelManager_java");
  String newContent2 = javaStr.replaceAll("package tool",
      "package " + packageName.replaceAll(".flutter2native", ""))
      .replaceAll("import java.lang.reflect.Type;", _javaChannelImport)
      .replaceAll("//generated add native2flutter impl in this", _javaImplStr)
      .replaceAll("private static final String channelName = \"123456\";",
      "private static final String channelName = \"${packageName}\";");
  androidSavePath += "/" + packageName.replaceAll(".", "/");
  File(androidSavePath + "/ChannelManager.java")
      .writeAsStringSync(newContent2);
}

void _genJavaCode(List<GenClassBean> list, String packageName, String savePath,
    String type) {
  packageName += type;
  savePath += "/" + packageName.replaceAll(".", "/");
  list.forEach((classBean) {
    classBean.imports
        .add("import ${packageName.replaceAll(type, "")}.ChannelManager;\n");
    classBean.methods
        .where((method) => method.returnType.type.startsWith("Future<"))
        .forEach((method) {
      String returnType = method.returnType.type;
      String callbackStr =
      returnType.replaceAll("Future<", "ChannelManager.Result<").trim();
      Property property = Property();
      property.type = callbackStr;
      property.name = "callback";
      property.typeInt = 0;
      method.args.add(property);
      method.returnType.type = "void";
    });
  });
  platforms_source_gent_start(
      packageName, //your android's  java class package name
      savePath, //your android file save path
      list);
}

////////////////////_gentJavaImpl/////////////////////////////////
////////////////////_gentJavaImpl/////////////////////////////////
////////////////////_gentJavaImpl/////////////////////////////////
////////////////////_gentJavaImpl/////////////////////////////////
String _javaChannelImport = "";
String _javaImplStr = "";

void _gentJavaImpl(List<GenClassBean> list, String packageName,
    String savePath) {
  //
  // import java.util.ArrayList;
  // import java.util.List;
  //
  // public class IAccountImpl implements IAccount{
  // @Override
  // public void getToken(Long teamId, String userId, ChannelManager.Result<String> callback){
  // List args = new ArrayList();
  // args.add(teamId);
  // args.add(userId);
  // ChannelManager.invoke(this.getClass(), "getToken", args, callback);
  // }
  // }

  String replaceFlutterType(String type) {
    JavaCreate.typeMap.forEach((key, value) {
      type = type.replaceAll(key, value);
    });
    type =
        type.replaceAll("List<", "ArrayList<").replaceAll("Map<", "HashMap<");
    return type;
  }

  packageName += ".native2flutter";
  savePath += "/" + packageName.replaceAll(".", "/");

  list.where((classBean) => classBean.classInfo.type == 1).forEach((classBean) {
    //impl interface
    String methodStr = "";
    classBean.methods.forEach((method) {
      bool hasCallback = false;
      String argNames = "";
      String argsStr = "";
      method.args.forEach((arg) {
        if (arg.type.contains("ChannelManager.Result<")) {
          hasCallback = true;
        } else {
          //not include callback
          argNames += "\t\targs.add(${arg.name});\n";
        }
        argsStr += "${replaceFlutterType(arg.type)} ${arg.name}, ";
      });
      if (argsStr.endsWith(", ")) {
        argsStr = argsStr.substring(0, argsStr.length - 2);
      }

      String methodContent = "\t\tList args = new ArrayList();\n" +
          argNames +
          "\t\tChannelManager.invoke(this.getClass().getInterfaces()[0], \"${method
              .name}\", args, ${hasCallback ? 'callback' : 'null'});\n";
      methodStr += "\t@Override\n" +
          "\tpublic void ${method.name}($argsStr) {\n" +
          methodContent +
          "\t}\n";
    });
    // import com.siyehua.spiexample.channel.native2flutter.Fps;
    // import com.siyehua.spiexample.channel.native2flutter.FpsImpl;
    _javaChannelImport +=
    "import ${packageName}.${classBean.classInfo.name};\n";
    _javaChannelImport +=
    "import ${packageName}.${classBean.classInfo.name}Impl;\n";
    _javaImplStr +=
    "addChannelImpl(${classBean.classInfo.name}.class, new ${classBean.classInfo
        .name}Impl());";

    String importStr =
        "import ${packageName.replaceAll(
            ".native2flutter", "")}.ChannelManager;\n" +
            "import java.util.List;\nimport java.util.ArrayList;\nimport java.util.HashMap;\n";
    String allContent = "package $packageName;\n\n" +
        importStr +
        "public class ${classBean.classInfo.name}Impl  implements ${classBean
            .classInfo
            .name}{\n" +
        methodStr +
        "}\n";
    Directory dir = Directory(savePath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    File impFile = File(dir.path + "/${classBean.classInfo.name}Impl.java");
    impFile.writeAsStringSync(allContent);
  });
}

////////////////////_genFlutterImpl/////////////////////////////////
////////////////////_genFlutterImpl/////////////////////////////////
////////////////////_genFlutterImpl/////////////////////////////////
////////////////////_genFlutterImpl/////////////////////////////////
String _channelImport = "import 'package:flutter/services.dart';\n";
String _implStr = "";

_genFlutterImpl(String flutterPath, String packageName,
    List<GenClassBean> list) {
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
        RegExp regExp = new RegExp(r"Future<List<\S+>>");
        if (regExp.hasMatch(method.returnType.type)) {
          returnStr = "List<Object> _a = await ";
          String type = method.returnType.type
              .replaceAll("Future<List<", "")
              .replaceAll(">>", "");
          exp =
          "\t\tList<$type> _b = _a.map((e) => e as $type).toList();\n\t\treturn _b;\n";
        } else if (new RegExp(r"Future<Map<.*,.*>>")
            .hasMatch(method.returnType.type)) {
          returnStr = "Map<dynamic, dynamic> _a = await ";
          List<String> type = method.returnType.type
              .replaceAll("Future<Map<", "")
              .replaceAll(">>", "")
              .split(",");
          exp =
          "\t\tMap<${type[0].trim()}, ${type[1]
              .trim()}> _b = _a.map((key, value) => MapEntry(key as ${type[0]
              .trim()}, value as ${type[1].trim()}));\n\t\treturn _b;\n";
        } else {
          returnStr = "return ";
        }
      }

      String methodContent = "\t\tType _clsType = ${classBean.classInfo
          .name};\n" +
          "\t\t$returnStr ChannelManager.invoke(package, _clsType.toString(), \"${method
              .name}\", ${argNames.isEmpty ? "" : argNames.toString()});\n" +
          exp;

      methodStr += "\t@override\n" +
          "\t${method.returnType.type} ${method.name}($argsStr) ${exp.isEmpty
              ? ""
              : "async "}{\n" +
          methodContent +
          "\t}\n";
    });
    _channelImport +=
        "import '../../flutter2native/${classBean.path
            .split("/")
            .last}';\n" +
            "import 'impl/${classBean.classInfo.name
                .toLowerCase()}_impl.dart';\n";
    _implStr +=
    "\t\tadd(${classBean.classInfo.name}, ${classBean.classInfo
        .name}Impl());\n";
    String importStr = "import '../ChannelManager.dart';\n" +
        "import '../../../flutter2native/${classBean.path
            .split("/")
            .last}';\n";
    String allContent = importStr +
        "class ${classBean.classInfo.name}Impl  implements ${classBean.classInfo
            .name}, PackageTag{\n" +
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
}


////////////////////_genFlutterParse/////////////////////////////////
////////////////////_genFlutterParse/////////////////////////////////
////////////////////_genFlutterParse/////////////////////////////////
////////////////////_genFlutterParse/////////////////////////////////

_genFlutterParse(String flutterPath, String packageName,
    List<GenClassBean> list) {
  String flutterSavePath = flutterPath + "/generated/channel";
  flutterPath += "/native2flutter";
  packageName += ".native2flutter";
  String methodContent = "";
  list
      .where((classBean) =>
  classBean.classInfo.type == 1 &&
      File(classBean.path).parent.path != flutterSavePath)
      .forEach((classBean) {
    //	T parse<T>(instance, String method, [dynamic args]) {
    // if ("getToken" == method) {
    //       return instance.getToken(args[0], args[1]) as T;
    //     }
    classBean.methods.forEach((method) {
      String argsStr = "";
      method.args.asMap().forEach((index, arg) {
        argsStr += "(args[${index}], ";
      });

      methodContent += "\t\tif (\"\$cls.${method.name}\" == \"\$cls.\$method\") {\n"
          + "\t\t\treturn instance.${method.name}(${argsStr}) as T;\n" + "\t\t}\n";
    });
  });

  String methodStr = "\tT parse<T>(instance, String cls, String method, [dynamic args]) {\n" +
      methodContent +
      "\t}\n";
  String allContent =
      "extension  IParse on Object{\n" +
      methodStr +
      "}\n";
  _channelImport += "import 'parse/object_parse.dart';\n";
  Directory dir = Directory(flutterSavePath + "/parse");
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  File impFile =
  File(dir.path + "/object_parse.dart");
  impFile.writeAsStringSync(allContent);
}

import 'dart:io';

import 'package:platforms_source_gen/platforms_source_gen.dart';
import 'package:platforms_source_gen/property_parse.dart';
import 'package:platforms_source_gen/android_gen.dart';
import './dart_channel_manager.dart';
import './java_channel_manager.dart';

void main() async {
  String flutterPath = "./lib/example";
  String packageName = "com.siyehua.platforms_channel_plugin.channel";
  String androidSavePath = "./android/src/main/kotlin";
  await spi_flutter_package_start(flutterPath, packageName, androidSavePath);
}

String createPasrseCode(Property property, {String paramsName = ""}) {
  var isEmpty = property.canBeNull ? "?" : "";
  var first = paramsName.isNotEmpty ? paramsName : "result";
  if (property.type == "dart.core.List") {
    // (result as List).map((e) => e as test(property.subType[0], e)).toList();
    return "($first as List$isEmpty)$isEmpty.map((result) => ${createPasrseCode(
        property.subType[0])}).toList()";
  } else if (property.type == "dart.core.Map") {
    // (result as Map).map((e) => e as MapEntry(
    //     test(property.subType[0], e), test(property.subType[1], e))).toList();
    return " ($first as Map$isEmpty)$isEmpty.map((key, value) =>  MapEntry(${createPasrseCode(
        property.subType[0], paramsName: "key")},${createPasrseCode(
        property.subType[1], paramsName: "value")}))";
  } else {
    return " $first as ${property.type
        .split(".")
        .last}$isEmpty ";
  }
}

Future<void> spi_flutter_package_start(String flutterPath, String packageName,
    String androidSavePath) async {
  await _flutter2Native(flutterPath, packageName, androidSavePath);
  await _native2flutter(flutterPath, packageName, androidSavePath);
  _gentManager(flutterPath, packageName, androidSavePath);
}

Future<void> _flutter2Native(String flutterPath, String packageName,
    String androidSavePath) async {
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

  _genFlutterImpl(flutterPath, packageName, list);
  _genJavaCode(list, packageName, androidSavePath, ".flutter2native");
}

Future<void> _native2flutter(String flutterPath, String packageName,
    String androidSavePath) async {
  Directory directory = Directory(flutterPath + "/native2flutter");
  if (!directory.existsSync()) {
    _genFlutterParse(flutterPath, packageName, []);
    return;
  }
  List<GenClassBean> list = await platforms_source_gen_init(
      flutterPath + "/native2flutter", //you dart file path
      packageName + ".native2flutter", //your android's  java class package name
      androidSavePath +
          "/" +
          packageName.replaceAll(".", "/") //your android file save path
  );
  if (list.isEmpty) {
    _genFlutterParse(flutterPath, packageName, []);
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
  String newContent = dartStr
      .replaceAll("import 'package:flutter/services.dart';", _channelImport)
      .replaceAll("static const _package = \"123567\";",
      "static const _package = \"${packageName}\";")
      .replaceAll("//replace", _implStr);
  Directory dir = Directory(flutterSavePath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  File file = File(flutterSavePath + "/channel_manager.dart");
  file.writeAsStringSync(newContent);
  if (!file.existsSync()) {
//if not create use dart io, use shell
    _savePath(newContent, file.path);
  }

  //create android manager
  // File file2 = File("./tool/ChannelManager_java");
  String newContent2 = javaStr
      .replaceAll("package tool",
      "package " + packageName.replaceAll(".flutter2native", ""))
      .replaceAll("import java.lang.reflect.Type;", _javaChannelImport)
      .replaceAll("//generated add native2flutter impl in this", _javaImplStr)
      .replaceAll("private static final String channelName = \"123456\";",
      "private static final String channelName = \"${packageName}\";");
  androidSavePath += "/" + packageName.replaceAll(".", "/");
  File androidFile = File(androidSavePath + "/ChannelManager.java");
  androidFile.createSync(recursive: true);
  androidFile.writeAsStringSync(newContent2);
  if (!androidFile.existsSync()) {
//if not create use dart io, use shell
    _savePath(newContent2, androidFile.path);
  }
}

void _genJavaCode(List<GenClassBean> list, String packageName, String savePath,
    String type) {
  packageName += type;
  savePath += "/" + packageName.replaceAll(".", "/");
  list.forEach((classBean) {
    classBean.imports.add(
        "import ${packageName.replaceAll(type, "")}.ChannelManager.Result;\n");
    classBean.methods
        .where((method) => method.returnType.type == "dart.async.Future")
        .forEach((method) {
      Property property = Property();
      property.type = "ChannelManager.Result";
      property.name = "callback";
      property.subType = method.returnType.subType;
      method.args.add(property);
      method.returnType.type = "void";
      method.returnType.subType = [];
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
        if (arg.type == "ChannelManager.Result") {
          hasCallback = true;
        } else {
          //not include callback
          argNames += "\t\targs.add(${arg.name});\n";
        }
        argsStr += "${JavaCreate.getTypeStr(arg)} ${arg.name}, ";
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
            "import ${packageName.replaceAll(
                ".native2flutter", "")}.ChannelManager.Result;\n" +
            "import java.util.List;\n"
                "import java.util.ArrayList;\n"
                "import java.util.HashMap;\n"
                "import org.jetbrains.annotations.NotNull;\n"
                "import org.jetbrains.annotations.Nullable;\n";
    String allContent = "package $packageName;\n\n" +
        importStr +
        "public class ${classBean.classInfo.name}Impl  implements ${classBean
            .classInfo.name}{\n" +
        methodStr +
        "}\n";
    Directory dir = Directory(savePath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    File impFile = File(dir.path + "/${classBean.classInfo.name}Impl.java");
    impFile.writeAsStringSync(allContent);
    if (!impFile.existsSync()) {
//if not create use dart io, use shell
      _savePath(allContent, impFile.path);
    }
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
        argsStr += "${getTypeStr(arg)} ${arg.name}, ";
      });

      String returnTypeStr = "void";
      if (method.returnType.type != "void") {
        returnTypeStr = getTypeStr(method.returnType);
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
        if (method.returnType.subType[0].type == "dart.core.List") {
          //list
          returnStr = "dynamic result = await ";
          String type = getTypeStr(method.returnType.subType[0]);
          String subType = getTypeStr(method.returnType.subType[0].subType[0]);
          exp =
          "\t\t$type _b = ${createPasrseCode(
              method.returnType.subType[0])};\n\t\treturn _b;\n";
        } else if (method.returnType.subType[0].type == "dart.core.Map") {
          returnStr = "dynamic result = await ";
          String type = getTypeStr(method.returnType.subType[0]);
          String subType1 = getTypeStr(method.returnType.subType[0].subType[0]);
          String subType2 = getTypeStr(method.returnType.subType[0].subType[1]);

          exp =
          "\t\t$type _b = ${createPasrseCode(
              method.returnType.subType[0])};\n\t\treturn _b;\n";
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
          "\t$returnTypeStr ${method.name}($argsStr) ${exp.isEmpty
              ? ""
              : "async "}{\n" +
          methodContent +
          "\t}\n";
    });
    String classPath = classBean.path
        .split("/")
        .last;
    classPath = classPath.substring(0, classPath.indexOf(".dart:") + 5);
    _channelImport += "import '../../flutter2native/$classPath';\n" +
        "import 'impl/${classBean.classInfo.name.toLowerCase()}_impl.dart';\n";
    _implStr +=
    "\t\tadd(${classBean.classInfo.name}, ${classBean.classInfo
        .name}Impl());\n";
    String importStr = "import '../channel_manager.dart';\n" +
        "import '../../../flutter2native/$classPath';\n";
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
    if (!impFile.existsSync()) {
      //if not create use dart io, use shell
      _savePath(allContent, impFile.path);
    }
  });
}

String getTypeStr(Property property) {
  String type = property.type
      .split(".")
      .last;
  if (property.subType.isNotEmpty) {
    type += "<";
    property.subType.forEach((element) {
      type += getTypeStr(element) + ", ";
    });
    if (type.endsWith(", ")) {
      type = type.substring(0, type.length - 2);
    }
    type += ">";
  }
  if (property.canBeNull) {
    type += "?";
  }
  return type;
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
      String extra = "";
      method.args.asMap().forEach((index, arg) {
        //	Map<dynamic, dynamic> a = (args[0] as Map);
        // 			Map<String,int> result = a.map((key, value) => MapEntry(key as String, value as int));
        extra += "\t\targs[$index] =  ${createPasrseCode(
            arg, paramsName: "args[$index]")};\n";
        argsStr += "args[$index], ";
      });

      methodContent +=
          "\t\tif(\"${classBean.classInfo.name}.${method
              .name}\" == \"\$cls.\$method\") {\n" + extra +
              "\t\t\treturn instance.${method.name}($argsStr);\n" +
              "\t\t}\n";
    });
  });

  String methodStr =
      "\tdynamic parse(instance, String cls, String method, [dynamic args]) {\n" +
          methodContent +
          "\t}\n";
  String allContent = "extension  IParse on Object{\n" + methodStr + "}\n";
  _channelImport += "import 'parse/object_parse.dart';\n";
  Directory dir = Directory(flutterSavePath + "/parse");
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  File impFile = File(dir.path + "/object_parse.dart");
  impFile.writeAsStringSync(allContent);
  if (!impFile.existsSync()) {
//if not create use dart io, use shell
    _savePath(allContent, impFile.path);
  }
}

void _savePath(String content, String path) {
  ProcessResult a = Process.runSync('bash',
      ['-c', "echo -e '${content.replaceAll("'", "\'\"\'\"\'")}' > $path"],
      runInShell: true);
  print(
      "file: $path \n create result: ${a.exitCode}\n err: ${a.stderr}\n out: ${a
          .stdout}");
}

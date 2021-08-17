import 'dart:io';

import 'package:platforms_source_gen/android_gen.dart';
import 'package:platforms_source_gen/gen_file_edit.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';

import 'file_config.dart';
import 'manager/manager_creater.dart';
import 'utils/android_file_utils.dart';
import 'utils/flutter_file_utils.dart';
import 'utils/ios_file_utils.dart';
import 'auto_gen_class_json.dart';
import 'spi_flutter_package.dart';

class Native2Flutter {
  static final List<FileConfig> fileConfigs = [];
}

Future<void> native2flutter(
  FlutterPlatformConfig flutterConfig,
  bool nullSafeSupport, {
  AndroidPlatformConfig? androidConfig,
  IosPlatformConfig? iosConfig,
}) async {
  Directory directory =
      Directory(flutterConfig.sourceCodePath + "/native2flutter");
  if (!directory.existsSync()) {
    _genFlutterParse([], flutterConfig.sourceCodePath,
        flutterConfig.channelName, nullSafeSupport);
    return;
  }
  List<GenClassBean> list = await platforms_source_gen_init(
    flutterConfig.sourceCodePath + "/native2flutter", //you dart file path
  );
  if (list.isEmpty) {
    _genFlutterParse([], flutterConfig.sourceCodePath,
        flutterConfig.channelName, nullSafeSupport);
    return;
  }
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
          Native2Flutter.fileConfigs.add(fileConfig);
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
        Native2Flutter.fileConfigs.add(fileConfig);
        break;
      }
    }
  });

  _genFlutterParse(list, flutterConfig.sourceCodePath,
      flutterConfig.channelName, nullSafeSupport);

  Native2Flutter.fileConfigs.asMap().forEach((index, config) {
    ////////////////////////android//////////////////////////
    ////////////////////////android//////////////////////////
    ////////////////////////android//////////////////////////
    if (androidConfig != null) {
      JavaFileUtils.genJavaCode(
          [list[index]],
          config.androidPlatformConfig!.packageName,
          config.androidPlatformConfig!.savePath,
          ".native2flutter",
          nullSafeSupport: nullSafeSupport);
      _gentJavaImpl(
          [list[index]],
          config.androidPlatformConfig!.packageName,
          config.androidPlatformConfig!.savePath,
          config.androidPlatformConfig!.channelName,
          nullSafeSupport);
    }
  });

  ////////////////////////ios//////////////////////////
  ////////////////////////ios//////////////////////////
  ////////////////////////ios//////////////////////////
  if (iosConfig != null) {
    ObjcFileUtils.genObjcCode(list, iosConfig.iosProjectPrefix,
        iosConfig.savePath, ".native2flutter");
    ObjcFileUtils.gentObjcImpl(
        list, iosConfig.iosProjectPrefix, iosConfig.savePath);
  }
}

void _genFlutterParse(
  List<GenClassBean> list,
  String flutterPath,
  String channelName,
  bool nullSafeSupport,
) {
  String flutterSavePath = flutterPath + "/generated/channel";
  flutterPath += "/native2flutter";
  String importStr = "";
  String methodContent = "";
  list
      .where((classBean) =>
          classBean.classInfo.type == 1 &&
          File(classBean.path).parent.path != flutterSavePath)
      .forEach((classBean) {
    classBean.imports.forEach((element) {
      if (element.startsWith("package:")) {
        importStr += element + "\n";
      } else {
        String newImport = element.replaceRange(
                "import '".length, "import '".length, "../../") +
            "\n";
        if (!importStr.contains(newImport)) {
          importStr += newImport;
        }
      }
    });
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
        extra +=
            "\t\targs[$index] =  ${FlutterFileUtils.createParseCode(arg, paramsName: "args[$index]")};\n";
        argsStr += "args[$index], ";
      });

      String customClassExtra = "";
      if (method.returnType.subType.isNotEmpty) {
        //		return	result.then((value) => "PageInfo___custom___" + jsonEncode(value.toJson()));
        method.returnType.subType[0].name = "value";
        customClassExtra =
            ".then((value) => ${FlutterFileUtils.parseMethodArgs(method.returnType.subType[0])})";
      }
      methodContent +=
          "\t\tif(\"${classBean.classInfo.name}.${method.name}\" == \"\$cls.\$method\") {\n" +
              extra +
              "\t\t\treturn instance.${method.name}($argsStr)$customClassExtra;\n" +
              "\t\t}\n";
    });
  });

  String methodStr =
      "\tdynamic parse(instance, String cls, String method, [dynamic args]) {\n" +
          methodContent +
          "\t}\n";
  String allContent =
      "import 'dart:typed_data';\nimport 'dart:convert';\n$importStr" +
          "extension  IParse on Object{\n" +
          methodStr +
          "}\n";
  if (!nullSafeSupport) {
    allContent = GenFileEdit.removeDartNullSafe(allContent);
  }
  ManagerUtils.dartManagerImport += "import 'parse/object_parse.dart';\n";
  Directory dir = Directory(flutterSavePath + "/parse");
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  File impFile = File(dir.path + "/object_parse.dart");
  impFile.writeAsStringSync(allContent);
}

void _gentJavaImpl(
  List<GenClassBean> list,
  String packageName,
  String savePath,
  String channelName,
  bool nullSafeSupport,
) {
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
          "\t\tChannelManager.invoke(this.getClass().getInterfaces()[0], \"${method.name}\", args, ${hasCallback ? 'callback' : 'null'});\n";
      methodStr += "\t@Override\n" +
          "\tpublic void ${method.name}($argsStr) {\n" +
          methodContent +
          "\t}\n";
    });
    // import com.siyehua.spiexample.channel.native2flutter.Fps;
    // import com.siyehua.spiexample.channel.native2flutter.FpsImpl;
    var finalSavePath = savePath;
    var info = ManagerUtils.managerInfo[savePath + channelName];
    if (info == null) {
      info = ManagerInfo();
      ManagerUtils.managerInfo[savePath + channelName] = info;
    }
    info.savePath = savePath;
    info.channelName = channelName;
    info.packageName = packageName.replaceAll(".native2flutter", "");
    info.javaManagerImport +=
        "import $packageName.${classBean.classInfo.name};\n"
        "import $packageName.${classBean.classInfo.name}Impl;\n";
    info.javaImplStr +=
        "\t\taddChannelImpl(${classBean.classInfo.name}.class, new ${classBean.classInfo.name}Impl());\n";
    String importStr =
        "import ${packageName.replaceAll(".native2flutter", "")}.ChannelManager;\n" +
            "import ${packageName.replaceAll(".native2flutter", "")}.ChannelManager.Result;\n" +
            "import java.util.List;\n"
                "import java.util.ArrayList;\n"
                "import java.util.HashMap;\n"
                "import org.jetbrains.annotations.NotNull;\n"
                "import org.jetbrains.annotations.Nullable;\n";
    String allContent = "package $packageName;\n\n" +
        importStr +
        "public class ${classBean.classInfo.name}Impl  implements ${classBean.classInfo.name}{\n" +
        methodStr +
        "}\n";
    if (!nullSafeSupport) {
      allContent = GenFileEdit.removeJavaNullSafe(allContent);
    }
    Directory dir =
        Directory(finalSavePath + "/" + packageName.replaceAll(".", "/"));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    File impFile = File(dir.path + "/${classBean.classInfo.name}Impl.java");
    impFile.writeAsStringSync(allContent);
  });
}

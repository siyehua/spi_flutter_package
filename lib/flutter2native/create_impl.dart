// import 'dart:io';
//
// import 'package:platforms_source_gen/android_gen.dart';
// import 'package:platforms_source_gen/platforms_source_gen.dart';
// import 'package:platforms_source_gen/property_parse.dart';
//
// import '../auto_gen_class_json.dart';
// import '../spi_flutter_package.dart';
//
// class CreateImpl {
//   static void genFlutterImpl(
//       String flutterPath, String packageName, List<GenClassBean> list) {
//     String flutterSavePath = flutterPath + "/generated/channel";
//     flutterPath += "/flutter2native";
//     packageName += ".flutter2native";
//
//     list
//         .where((classBean) =>
//             classBean.classInfo.type == 1 &&
//             File(classBean.path).parent.path != flutterSavePath)
//         .forEach((classBean) {
//       //impl interface
//       String methodStr = "";
//       classBean.methods.forEach((method) {
//         List<String> argNames = [];
//         String argsStr = "";
//         method.args.forEach((arg) {
//           if (JavaCreate.typeMap.containsKey(arg.type)) {
//             argNames.add(arg.name);
//           } else {
//             //custom class
//             //"InnerClass___custom___"+jsonEncode(abc.toJson())
//             String formatStr =
//                 "\"${getPropertyNameStr(arg)}___custom___\" + jsonEncode(${arg.name}.toJson())";
//             argNames.add(formatStr);
//           }
//           argsStr += "${getTypeStr(arg)} ${arg.name}, ";
//         });
//
//         String returnTypeStr = "void";
//         if (method.returnType.type != "void") {
//           returnTypeStr = getTypeStr(method.returnType);
//         }
//
//         String returnStr = "";
//         String exp = "";
//         if (method.returnType.type != "void") {
//           //	Type clsType = IShare;
//           // 		List<dynamic> a = await ChannelManager.invoke(package, clsType.toString(), "getFeedList", []);
//           // 		List<String> b = a.map((e) => e as String).toList();
//           // 		return b;
//           // Type clsType = IAccount;
//           //     Map<dynamic, dynamic> a = await ChannelManager.invoke(package, clsType.toString(), "a22222222",);
//           //     Map<String, bool> b = a.map((key, value) => MapEntry(key as String, value as bool));
//           //     return b;
//           if (method.returnType.subType[0].type == "dart.core.List") {
//             //list
//             returnStr = "dynamic result = await ";
//             String type = getTypeStr(method.returnType.subType[0]);
//             exp =
//                 "\t\t$type _b = ${createParseCode(method.returnType.subType[0])};\n\t\treturn _b;\n";
//           } else if (method.returnType.subType[0].type == "dart.core.Map") {
//             returnStr = "dynamic result = await ";
//             String type = getTypeStr(method.returnType.subType[0]);
//             exp =
//                 "\t\t$type _b = ${createParseCode(method.returnType.subType[0])};\n\t\treturn _b;\n";
//           } else {
//             returnStr = "return await ";
//           }
//         }
//
//         String methodContent =
//             "\t\tType _clsType = ${classBean.classInfo.name};\n" +
//                 "\t\t$returnStr ChannelManager.invoke(package, _clsType.toString(), \"${method.name}\", ${argNames.isEmpty ? "" : argNames.toString()});\n" +
//                 exp;
//
//         methodStr += "\t@override\n" +
//             "\t$returnTypeStr ${method.name}($argsStr) async{\n" +
//             methodContent +
//             "\t}\n";
//       });
//       String classPath = classBean.path.split("/").last;
//       String filePreName =
//           classBean.classInfo.name.replaceAllMapped(RegExp("[A-Z]"), (match) {
//         // print("${match.input} + match:${ match.group(0)}");
//         return "_" + match.group(0)!.toLowerCase();
//       });
//       print(filePreName);
//       if (filePreName.startsWith("_")) {
//         filePreName = filePreName.replaceFirst("_", "");
//       }
//       classPath = classPath.substring(0, classPath.indexOf(".dart:") + 5);
//       _channelImport += "import '../../flutter2native/$classPath';\n" +
//           "import 'impl/${filePreName}_impl.dart';\n";
//       _implStr +=
//           "\t\tadd(${classBean.classInfo.name}, ${classBean.classInfo.name}Impl());\n";
//       String importStr = "import '../channel_manager.dart';\n" +
//           "import '../../../flutter2native/$classPath';\n" +
//           "import 'dart:convert';\n" +
//           "import 'dart:typed_data';\n";
//       String allContent = importStr +
//           "class ${classBean.classInfo.name}Impl  implements ${classBean.classInfo.name}, PackageTag{\n" +
//           methodStr +
//           "\t@override\n\tString package = \"$packageName\";\n" +
//           "}\n";
//       Directory dir = Directory(flutterSavePath + "/impl");
//       if (!dir.existsSync()) {
//         dir.createSync(recursive: true);
//       }
//       File impFile = File(dir.path + "/${filePreName}_impl.dart");
//       impFile.writeAsStringSync(allContent);
//     });
//   }
//
//   String _parseMethodArgs(Property arg) {
//     if (isBaseType(arg)) {
//       return arg.name;
//     } else if (isListType(arg)) {
//       // list.map((e) => "InnerClass___custom___" + jsonEncode(abc.toJson())).toList()
//       arg.subType[0].name = "e";
//       return "${arg.name}.map((e) => ${_parseMethodArgs(arg.subType[0])}).toList()";
//     } else if (isMapType(arg)) {
//       arg.subType[0].name = "k";
//       arg.subType[1].name = "v";
//       return "${arg.name}.map((k,v) => ${_parseMethodArgs(arg.subType[0])}, ${_parseMethodArgs(arg.subType[1])})";
//     } else {
//       //custom class
//       //"InnerClass___custom___"+jsonEncode(abc.toJson())
//       String formatStr =
//           "\"${getPropertyNameStr(arg)}___custom___\" + jsonEncode(${arg.name}.toJson())";
//       return formatStr;
//     }
//   }
// }

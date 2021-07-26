import 'dart:io';

import 'package:platforms_source_gen/bean/property_parse.dart';
import 'package:platforms_source_gen/gen_file_edit.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';
import 'package:platforms_source_gen/type_utils.dart';
import 'package:spi_flutter_package/utils/flutter_file_utils.dart';

/// add json method to dart source code
/// note : if class change, should delete auto create code.
Future<void> autoCreateJsonParse(
    List<GenClassBean> genClasses, String sourcePath, bool nullSafe) async {
  var fileInsertCount = <String, int>{};
  genClasses.where((value) => value.classInfo.type == 0).where((value) {
    bool hasToJsonMethod =
        value.methods.where((element) => element.name == "toJson").isEmpty;
    print("filter: ${value.classInfo.name} $hasToJsonMethod");
    return hasToJsonMethod;
  }).forEach((classInfo) {
    // print("filter result: ${classInfo.classInfo.name}");
    String classPath = classInfo.path.split(":")[1];
    classPath = "./lib" + classPath.substring(classPath.indexOf("/"));
    if (!fileInsertCount.containsKey(classPath)) {
      fileInsertCount[classPath] = 0;
    }
    String wantInsertLine = classInfo.path.split(":")[2];
    // package:flutter_module/channel/flutter2native/account.dart:49:1
    String content = _createDefaultConstructor(classInfo) + "\n";
    content += _createFromJsonMethod(classInfo) + "\n";
    content += _createToJsonMethod(classInfo) + "\n";
    if (!nullSafe) {
      content = GenFileEdit.removeDartNullSafe(content);
    }
    RegExp regExp = RegExp("\n");
    List<String> newContentList = File(classPath).readAsLinesSync();
    int newLineCount = fileInsertCount[classPath]!;
    newContentList.insert(int.parse(wantInsertLine) + newLineCount, content);
    String newContent = "";
    newLineCount += regExp.allMatches(content).length;
    newLineCount++;
    fileInsertCount[classPath] = newLineCount;
    newContentList.forEach((element) {
      newContent += element + "\n";
    });
    File(classPath).writeAsStringSync(newContent);
  });
  for (var k in fileInsertCount.keys) {
    ProcessResult result =
        await Process.run('dart', ['format', k], runInShell: true);
  }
}

String _createToJsonMethod(GenClassBean classInfo) {
  //
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = Map<String, dynamic>();
//   data['name'] = this.name;
//   data['isAbstract'] = this.isAbstract;
//   data['args'] = this.args.map((v) => v.toJson()).toList();
//   data['returnType'] = this.returnType.toJson();
//   return data;
// }
  String propertyStr = "";
  classInfo.properties.where((value) => !value.isStatic).forEach((property) {
    propertyStr += _getJsonStr(property);
    if (!propertyStr.endsWith("}")) {
      propertyStr += ";";
    }
  });
  return """
        /// Note: this method create by SPI, if change Class property or method,
        /// please remove it. it will be created by SPI again.
        Map<String, dynamic> toJson() {
            final Map<String, dynamic> data = Map<String, dynamic>();
            $propertyStr
            return data;
        }
        """;
}

bool isObject(Property property) {
  return property.type == "dart.core.Object";
}

String _getJsonStr(Property property, {String propertyName = ""}) {
  String question = "";
  if (property.canBeNull) {
    question = "?";
  }
  if (property.name.isEmpty) {
    if (TypeUtils.isBaseType(property) || isObject(property)) {
      return propertyName;
    } else if (TypeUtils.isListType(property)) {
      return "$propertyName$question.map((v) => ${_getJsonStr(property.subType[0], propertyName: 'v')}).toList()";
    } else if (TypeUtils.isMapType(property)) {
      return "$propertyName$question.map((k, v) => MapEntry(${_getJsonStr(property.subType[0], propertyName: 'k')}"
          ", ${_getJsonStr(property.subType[1], propertyName: 'v')}))";
    } else {
      return "$propertyName$question.toJson()";
    }
  }

  if (TypeUtils.isBaseType(property) || isObject(property)) {
    return "data['${property.name}'] = this.${property.name}";
  } else if (TypeUtils.isListType(property)) {
    return "data['${property.name}'] = this.${property.name}$question.map((v) => ${_getJsonStr(property.subType[0], propertyName: "v")}).toList()";
  } else if (TypeUtils.isMapType(property)) {
    return "data['${property.name}'] = this.${property.name}$question.map((k, v) => MapEntry(${_getJsonStr(property.subType[0], propertyName: "k")}"
        ", ${_getJsonStr(property.subType[1], propertyName: "v")}))";
  } else {
    return "data['${property.name}'] = ${property.name}$question.toJson()";
  }
}

String _createDefaultConstructor(GenClassBean classInfo) {
  return "/// Note: this method create by SPI, if change Class property or method,\n"
      "/// please remove it. it will be created by SPI again.\n"
      "${classInfo.classInfo.name}();";
}

String _createFromJsonMethod(GenClassBean classInfo) {
// MethodInfo.fromJson(Map<String, dynamic> json) {
// name = json['name'];
// isAbstract = json['isAbstract'];
// if (json['args'] != null) {
// args = [];
// json['args'].forEach((v) {
// args.add(Property.fromJson(v));
// });
// }
// returnType = json['returnType'] != null
// ? Property.fromJson(json['returnType'])
//     : Property();
// }
  print("start parse json:" + classInfo.classInfo.name);

  String propertyStr = "";
  classInfo.properties.where((value) => !value.isStatic).forEach((property) {
    propertyStr += getParseStr(property);
    if (!propertyStr.endsWith("}")) {
      propertyStr += ";";
    }
  });

  String allContent =
      "/// Note: this method create by SPI, if change Class property or method,\n"
      "/// please remove it. it will be created by SPI again.\n"
      "${classInfo.classInfo.name}.fromJson(Map<String, dynamic> json) {$propertyStr}";

  return allContent;
}

String getParseStr(Property property, {String propertyName = ""}) {
  if (property.name.isEmpty) {
    return "${TypeUtils.getPropertyNameStr(property)}.fromJson(json['${property.name}'])";
  }
  String shouldAddNullCover = "";
  if (property.canBeNull) {
    shouldAddNullCover = "!";
  }
  if (TypeUtils.isListType(property)) {
    return """if (json['${property.name}'] != null) {
              ${property.name} =[];
              json['${property.name}'].forEach((v) {
              ${property.name}$shouldAddNullCover.add(${FlutterFileUtils.createParseCode(property.subType[0], paramsName: "v")});
              });
            }""";
  } else if (TypeUtils.isMapType(property)) {
    //        i2!.update(k as String?, (value) =>(v as int),ifAbsent: ()=> (v as int));
    return """if (json['${property.name}'] != null) {
              ${property.name} ={};
              json['${property.name}'].forEach((k, v) {
              ${property.name}$shouldAddNullCover.update(${FlutterFileUtils.createParseCode(property.subType[0], paramsName: "k")}
              , (value) => ${FlutterFileUtils.createParseCode(property.subType[1], paramsName: "v")}
              , ifAbsent: ()=> ${FlutterFileUtils.createParseCode(property.subType[1], paramsName: "v")});
              });
            }""";
  } else if (TypeUtils.isBaseType(property) || isObject(property)) {
    return "${property.name} = json['${property.name}']";
  } else {
    return "${property.name} = ${TypeUtils.getPropertyNameStr(property)}.fromJson(json['${property.name}'])";
  }
}

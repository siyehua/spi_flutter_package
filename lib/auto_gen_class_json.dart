import 'dart:io';

import 'package:platforms_source_gen/android_gen.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';
import 'package:platforms_source_gen/property_parse.dart';
import 'package:spi_flutter_package/spi_flutter_package.dart';

Future<void> autoCreateJsonParse(
    List<GenClassBean> genClasses, String sourcePath) async {
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
  return """Map<String, dynamic> toJson() {
            final Map<String, dynamic> data = Map<String, dynamic>();
            $propertyStr
            return data;
        }
        """;
}

String _getJsonStr(Property property, {String propertyName = ""}) {
  String question = "";
  if (property.canBeNull) {
    question = "?";
  }
  if (property.name.isEmpty) {
    if (isBaseType(property)) {
      return propertyName;
    } else if (isListType(property)) {
      return "$propertyName$question.map((v) => ${_getJsonStr(property.subType[0], propertyName: 'v')}).toList()";
    } else if (isMapType(property)) {
      return "$propertyName$question.map((k, v) => MapEntry(${_getJsonStr(property.subType[0], propertyName: 'k')}"
          ", ${_getJsonStr(property.subType[1], propertyName: 'v')}))";
    } else {
      return "$propertyName$question.toJson()";
    }
  }

  if (isBaseType(property)) {
    return "data['${property.name}'] = this.${property.name}";
  } else if (isListType(property)) {
    return "data['${property.name}'] = this.${property.name}$question.map((v) => ${_getJsonStr(property.subType[0], propertyName: "v")}).toList()";
  } else if (isMapType(property)) {
    return "data['${property.name}'] = this.${property.name}$question.map((k, v) => MapEntry(${_getJsonStr(property.subType[0], propertyName: "k")}"
        ", ${_getJsonStr(property.subType[1], propertyName: "v")}))";
  } else {
    return "data['${property.name}'] = ${property.name}.toJson()";
  }
}

String _createDefaultConstructor(GenClassBean classInfo) {
  return "${classInfo.classInfo.name}();";
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
      "${classInfo.classInfo.name}.fromJson(Map<String, dynamic> json) {$propertyStr}";

  return allContent;
}

String getParseStr(Property property, {String propertyName = ""}) {
  if (property.name.isEmpty) {
    return "${getPropertyNameStr(property)}.fromJson(json['${property.name}'])";
  }
  String shouldAddNullCover = "";
  if (property.canBeNull) {
    shouldAddNullCover = "!";
  }
  if (isListType(property)) {
    return """if (json['${property.name}'] != null) {
              ${property.name} =[];
              json['${property.name}'].forEach((v) {
              ${property.name}$shouldAddNullCover.add(${createParseCode(property.subType[0], paramsName: "v")});
              });
            }""";
  } else if (isMapType(property)) {
    //        i2!.update(k as String?, (value) =>(v as int),ifAbsent: ()=> (v as int));
    return """if (json['${property.name}'] != null) {
              ${property.name} ={};
              json['${property.name}'].forEach((k, v) {
              ${property.name}$shouldAddNullCover.update(${createParseCode(property.subType[0], paramsName: "k")}
              , (value) => ${createParseCode(property.subType[1], paramsName: "v")}
              , ifAbsent: ()=> ${createParseCode(property.subType[1], paramsName: "v")});
              });
            }""";
  } else if (isBaseType(property)) {
    return "${property.name} = json['${property.name}']";
  } else {
    return "${property.name} = ${getPropertyNameStr(property)}.fromJson(json['${property.name}'])";
  }
}

String getPropertyNameStr(Property property) {
  return property.type.split(".").last;
}

bool isListType(Property property) {
  return property.type == "dart.core.List";
}

bool isMapType(Property property) {
  return property.type == "dart.core.Map";
}

bool isBaseType(Property property) {
  if (isListType(property)) {
    return false;
  }
  if (isMapType(property)) {
    return false;
  }
  return JavaCreate.typeMap.containsKey(property.type);
}

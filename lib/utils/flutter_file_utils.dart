import 'package:platforms_source_gen/bean/property_parse.dart';
import 'package:platforms_source_gen/type_utils.dart';

class FlutterFileUtils {
  static String parseMethodArgs(Property arg) {
    String question = "";
    if (arg.canBeNull) {
      question = "?";
    }
    if (TypeUtils.isBaseType(arg)) {
      return arg.name;
    } else if (TypeUtils.isListType(arg)) {
      // list.map((e) => "InnerClass___custom___" + jsonEncode(abc.toJson())).toList()
      arg.subType[0].name = "e";
      return "${arg.name}$question.map((e) => "
          "${parseMethodArgs(arg.subType[0])}).toList()";
    } else if (TypeUtils.isMapType(arg)) {
      arg.subType[0].name = "k";
      arg.subType[1].name = "v";
      return "${arg.name}$question.map((k,v) => "
          "MapEntry(${parseMethodArgs(arg.subType[0])}, "
          "${parseMethodArgs(arg.subType[1])}))";
    } else {
      //custom class
      //"InnerClass___custom___"+jsonEncode(abc.toJson())
      String formatStr =
          "\"${TypeUtils.getPropertyNameStr(arg)}___custom___\" + jsonEncode(${arg.name}$question.toJson())";
      return formatStr;
    }
  }

  static String createParseCode(Property property, {String paramsName = ""}) {
    var isEmpty = property.canBeNull ? "?" : "";
    var first = paramsName.isNotEmpty ? paramsName : "result";
    if (property.type == "dart.core.List") {
      // (result as List).map((e) => e as test(property.subType[0], e)).toList();
      return "($first as List$isEmpty)$isEmpty.map((result) => ${createParseCode(property.subType[0])}).toList()";
    } else if (property.type == "dart.core.Map") {
      // (result as Map).map((e) => e as MapEntry(
      //     test(property.subType[0], e), test(property.subType[1], e))).toList();
      return " ($first as Map$isEmpty)$isEmpty.map((key, value) =>  MapEntry(${createParseCode(property.subType[0], paramsName: "key")},${createParseCode(property.subType[1], paramsName: "value")}))";
    } else if (TypeUtils.isBaseType(property)) {
      return " $first as ${TypeUtils.getPropertyNameStr(property)}$isEmpty ";
    } else {
      //custom class
      return "${TypeUtils.getPropertyNameStr(property)}.fromJson(jsonDecode($first.split(\"___custom___\")[1]))";
    }
  }

  static String getTypeStr(Property property) {
    String type = TypeUtils.getPropertyNameStr(property);
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
}

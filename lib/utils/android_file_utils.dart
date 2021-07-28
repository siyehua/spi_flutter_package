import 'package:platforms_source_gen/bean/property_parse.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';

class JavaFileUtils {
  static void genJavaCode(
    List<GenClassBean> list,
    String packageName,
    String savePath,
    String type, {
    bool nullSafeSupport = true,
  }) {
    packageName += type;
    savePath += "/" + packageName.replaceAll(".", "/");
    list.forEach((classBean) {
      var newImport = <String>[];
      String reg = "";
      if (type.contains("flutter2native")) {
        reg = "native2flutter";
      } else {
        reg = "flutter2native";
      }
      if (classBean.imports.every((element) {
        return element.contains(reg);
      })) {
        newImport.add("import  ${packageName.replaceAll(type, "")}.$reg.*;\n");
      }
      classBean.imports = newImport;
      String tmpImport =
          "import ${packageName.replaceAll(type, "")}.ChannelManager.Result;\n";
      if (!classBean.imports.contains(tmpImport)) {
        classBean.imports.add(tmpImport);
      }
    });
    platforms_source_gent_start(
        packageName, //your android's  java class package name
        savePath, //your android file save path
        list,
        nullSafe: nullSafeSupport);
  }
}

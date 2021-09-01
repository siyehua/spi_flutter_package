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
      classBean.imports = <String>[];
      String tmpImport =
          "import ${packageName.replaceAll(type, "")}.ChannelManager.Result;\n";
      if (!classBean.imports.contains(tmpImport)) {
        classBean.imports.add(tmpImport);
      }

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
        list,
        nullSafe: nullSafeSupport);
  }
}

import 'package:platforms_source_gen/bean/property_parse.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';

class ObjcFileUtils {
  static void genObjcCode(
    List<GenClassBean> list,
    String projectPrefix,
    String savePath,
    String type, {
    bool nullSafeSupport = true,
  }) {
    savePath += "/" + (projectPrefix + type).replaceAll(".", "/");
    list.forEach((classBean) {
      String reg = "";
      if (type.contains("flutter2native")) {
        reg = "native2flutter";
      } else {
        reg = "flutter2native";
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
    genIOSCode("MQQFlutterGen_", savePath, list, nullSafe: nullSafeSupport);
  }
}

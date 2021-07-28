import 'package:platforms_source_gen/bean/property_parse.dart';
import 'package:platforms_source_gen/platforms_source_gen.dart';
import 'dart:io';

class ObjcFileUtils {
  static void genObjcCode(
    List<GenClassBean> list,
    String projectPrefix,
    String savePath,
    String type, {
    bool nullSafeSupport = true,
  }) {
    savePath += "/" + (projectPrefix + type).replaceAll(".", "/");
    platforms_source_start_gen_objc(projectPrefix, savePath, list,
        nullSafe: nullSafeSupport);
    List<FileSystemEntity> generatedFile = Directory(savePath).listSync();
    generatedFile.forEach((entity) {
      if (entity is File) {
        String content = entity.readAsStringSync();
        content = content
            .replaceAll("${projectPrefix}Result<", "void(^)(")
            .replaceAll("> *)__callback", "))callback")
            .replaceAll("__", "");
        entity.writeAsStringSync(content, flush: true);
      }
    });
  }
}

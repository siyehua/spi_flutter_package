import 'package:platforms_source_gen/bean/class_parse.dart';
import 'package:platforms_source_gen/ios_gen.dart';
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
    convertResultType(savePath, projectPrefix);
  }

  static void gentObjcImpl(
      List<GenClassBean> list, String projectPrefix, String savePath) {
    savePath += "/" + projectPrefix + "/native2flutter";

    list
        .where((classBean) => classBean.classInfo.type == ClassType.abstract)
        .forEach((classBean) {
      String interfaceString = "";
      String implementationString = "";
      String protocolName = "$projectPrefix${classBean.classInfo.name}";
      String className = "${protocolName}Imp";
      // interface
      {
        interfaceString = '''
#import <Foundation/Foundation.h>
#import \"$protocolName.h\"

NS_ASSUME_NONNULL_BEGIN

@interface $className : NSObject <$protocolName>

@end

NS_ASSUME_NONNULL_END
''';
      }
      // implementation
      {
        classBean.methods.forEach((method) {
          bool hasCallback = false;
          String argNames = "";
          String argsStr = "";
          method.args.forEach((arg) {
            if (arg.type == "ChannelManager.Result") {
              hasCallback = true;
            } else {
              //not include callback
              if (ObjectiveCCreate.typeOf(arg) == ObjectivePropertType.base) {
                argNames += "\t[args addObject:@(${arg.name})];\n";
              } else {
                argNames += "\t[args addObject:${arg.name}];\n";
              }
            }
            argsStr += "${ObjectiveCCreate.getTypeString(arg)} ${arg.name}, ";
          });
          if (argsStr.endsWith(", ")) {
            argsStr = argsStr.substring(0, argsStr.length - 2);
          }

          String methodContent =
              "\tNSMutableArray *args = [NSMutableArray array];\n" +
                  argNames +
                  "\t[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@\"${method.name}\" args:args fromClass:self.class completion:${hasCallback ? 'callback' : 'nil'}];\n";
          implementationString +=
              "${ObjectiveCCreate.method([method]).replaceAll(";", "")} {\n" +
                  methodContent +
                  "}\n\n";
        });

        String importStr =
            "#import \"$className.h\"\n#import \"${projectPrefix}ChannelManager.h\"\n";
        String allContent = importStr +
            "NS_ASSUME_NONNULL_BEGIN\n\n@implementation $className\n" +
            implementationString +
            "@end\nNS_ASSUME_NONNULL_END\n";
        Directory dir = Directory(savePath);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        File headerFile = File(dir.path + "/$className.h");
        File impFile = File(dir.path + "/$className.m");
        headerFile.writeAsStringSync(interfaceString);
        impFile.writeAsStringSync(allContent);
      }
    });
    convertResultType(savePath, projectPrefix);
  }

  static void convertResultType(String savePath, String projectPrefix) {
    List<FileSystemEntity> generatedFile = Directory(savePath).listSync();
    generatedFile.forEach((entity) {
      if (entity is File) {
        String content = entity.readAsStringSync();
        content = content
            .replaceAll("${projectPrefix}Result<", "void(^)(")
            .replaceAll("> *)callback", "))callback")
            .replaceAll("#import \"MQQFlutterGen_Result.h\"", "");
        entity.writeAsStringSync(content, flush: true);
      }
    });
  }
}

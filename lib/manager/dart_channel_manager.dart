String dartStr = '''
import 'dart:collection';

import 'package:flutter/services.dart';

abstract class PackageTag {
  String package = "";
}

abstract class Parse {
  T parse<T>(dynamic account, String method, [dynamic args]);
}

abstract class _ErrorCode {
  static String NoFoundChannel = "400"; //can't found channel
  static String NoFoundMethod = "401"; //can't found method
  static String CanNotMatchArgs = "402"; //can not match method's args
}

/// custom doc should replace
/// ChannelManager manager all changer interfaces.<br>
/// add interface impl, use [add] method,<br>
/// get interface impl, use [getChannel].<br>
/// more info, see {@link 'https://pub.dev/packages/spi_flutter_package'}
class ChannelManager {
  static const _package = "123567";
  static const _platform = const MethodChannel(_package);
  static final _channelImplMap = new HashMap<String, dynamic>();

  static void add(Type type, dynamic impl) {
    _channelImplMap[type.toString()] = impl;
  }
  
  static void remove(Type type){
    _channelImplMap.remove(type);
  }
  
  static void init() {
//replace

    _platform.setMethodCallHandler((MethodCall call) async {
      String callClass = call.method.split("#")[0];
      String callMethod = call.method.split("#")[1];
      String cls = callClass
          .replaceAll("interface ", "")
          .replaceAll(_package + ".native2flutter.", "");
      dynamic targetChanel = _channelImplMap[cls];
      if (targetChanel != null) {
        return (targetChanel as Object)
            .parse(targetChanel, cls, callMethod, call.arguments);      
      } else {
        return _ErrorCode.NoFoundChannel.toString();
        // result.error(ErrorCode.NoFoundChannel, "can't found channel: " + callClass
        // + ", do you call ChannelManager.addChannelImpl() in Android Platform ?", null);
      }
    });
  }

  static Future<T?> invoke<T>(String packageName, String clsName, String method, String argNames,
      [dynamic arguments]) {
    return _platform.invokeMethod(
        packageName + "." + clsName + "#" + method + "#" + argNames, arguments);
  }

  static T getChannel<T>(Type clsName) {
    return _channelImplMap[clsName.toString()];
  }
}
''';

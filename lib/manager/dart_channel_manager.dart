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

///
/// ChannelManager manager all changer interfaces.<br>
/// add interface impl, use [add] method,<br>
/// get interface impl, use [getChannel].<br>
/// more info, see {@link 'https://pub.dev/packages/spi_flutter_package'}
class ChannelManager {
  static final _packages = <String>[];
  static final _platforms = <MethodChannel>[];
  static final _channelImplMap = new HashMap<String, dynamic>();

  static void add(Type type, dynamic impl) {
    _channelImplMap[type.toString()] = impl;
  }

  static void remove(Type type) {
    _channelImplMap.remove(type);
  }

  static void init() {
//replace

//_packages.add

    _packages.forEach((channelName) {
      var methodChannel = MethodChannel(channelName);
      _platforms.add(methodChannel);
      _addListener(methodChannel, channelName);
    });
  }

  static void _addListener(MethodChannel _platform, String _package) {
    _platform.setMethodCallHandler((MethodCall call) async {
      String callClass = call.method.split("#")[0];
      String callMethod = call.method.split("#")[1];
      String cls = callClass.split(".").last;
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

  static Future<T?> invoke<T>(String channelName, String packageName,
      String clsName, String method, String argNames,
      [dynamic arguments]) {
    int index = _packages.indexOf(channelName);
    return _platforms[index].invokeMethod(
        packageName + "." + clsName + "#" + method + "#" + argNames, arguments);
  }

  static T getChannel<T>(Type clsName) {
    return _channelImplMap[clsName.toString()];
  }
}
''';

import 'dart:collection';

import 'package:flutter/services.dart';
import '../../flutter2native/example.dart';
import 'impl/iaccount_impl.dart';
import 'parse/object_parse.dart';


abstract class PackageTag {
  String package;
}

abstract class Parse {
  T parse<T>(dynamic account, String method, [dynamic args]);
}

abstract class _ErrorCode {
  static String NoFoundChannel = "400"; //can't found channel
  static String NoFoundMethod = "401"; //can't found method
  static String CanNotMatchArgs = "402"; //can not match method's args
}

class ChannelManager {
  static const _package = "com.siyehua.platforms_channel_plugin.channel";
  static const _platform = const MethodChannel(_package);
  static final _channelImplMap = new HashMap<String, dynamic>();

  static void add(Type type, dynamic impl) {
    _channelImplMap[type.toString()] = impl;
  }

  static void init() {
    		add(IAccount, IAccountImpl());


    _platform.setMethodCallHandler((MethodCall call) async {
      String callClass = call.method.split("#")[0];
      String callMethod = call.method.split("#")[1];
      String cls = callClass
          .replaceAll("interface ", "")
          .replaceAll(_package + ".native2flutter.", "");
      dynamic targetChanel = _channelImplMap[cls];
      if (targetChanel != null) {
        return (targetChanel as Object).parse(targetChanel, cls, callMethod, call.arguments);
      } else {
        return _ErrorCode.NoFoundChannel.toString();
        // result.error(ErrorCode.NoFoundChannel, "can't found channel: " + callClass
        // + ", do you call ChannelManager.addChannelImpl() in Android Platform ?", null);
      }
    });
  }

  static Future<T> invoke<T>(String packageName, String clsName, String method,
      [dynamic arguments]) {
    return _platform.invokeMethod(
        packageName + "." + clsName + "#" + method, arguments);
  }

  static T getChannel<T>(Type clsName) {
    return _channelImplMap[clsName.toString()];
  }
}


abstract class PlatformConfig {
  /// save path
  String savePath = "";

  /// channel name
  String channelName = "";

  /// use channel type， default is method channel
  int channelType = 0;

  /// custom channel manager doc
  String customDoc = "";
}

class FlutterPlatformConfig with PlatformConfig {
  String sourceCodePath = "";
}

class AndroidPlatformConfig with PlatformConfig {
  String packageName = "";
}

class IosPlatformConfig with PlatformConfig {
  String iosProjectPrefix = "";
}

abstract class FileConfig {
  FlutterPlatformConfig? flutterConfig() {}

  AndroidPlatformConfig? androidConfig() {}

  IosPlatformConfig? iosConfig() {}
}

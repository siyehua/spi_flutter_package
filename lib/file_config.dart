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

class FileConfig {
  FlutterPlatformConfig flutterPlatformConfig = FlutterPlatformConfig();
  AndroidPlatformConfig? androidPlatformConfig = AndroidPlatformConfig();
  IosPlatformConfig? iosPlatformConfig = IosPlatformConfig();

  FileConfig.copy(
      FlutterPlatformConfig flutterPlatformConfig,
      AndroidPlatformConfig? androidPlatformConfig,
      IosPlatformConfig? iosPlatformConfig) {
    this.flutterPlatformConfig.sourceCodePath =
        flutterPlatformConfig.sourceCodePath;
    this.flutterPlatformConfig.savePath = flutterPlatformConfig.savePath;
    this.flutterPlatformConfig.channelName = flutterPlatformConfig.channelName;
    this.flutterPlatformConfig.channelType = flutterPlatformConfig.channelType;
    this.flutterPlatformConfig.customDoc = flutterPlatformConfig.customDoc;

    this.androidPlatformConfig?.packageName =
        androidPlatformConfig?.packageName ?? "";
    this.androidPlatformConfig?.savePath =
        androidPlatformConfig?.savePath ?? "";
    this.androidPlatformConfig?.channelName =
        androidPlatformConfig?.channelName ?? "";
    this.androidPlatformConfig?.channelType =
        androidPlatformConfig?.channelType ?? 0;
    this.androidPlatformConfig?.customDoc =
        androidPlatformConfig?.customDoc ?? "";

    this.iosPlatformConfig?.iosProjectPrefix =
        iosPlatformConfig?.iosProjectPrefix ?? "";
    this.iosPlatformConfig?.savePath = iosPlatformConfig?.savePath ?? "";
    this.iosPlatformConfig?.channelName = iosPlatformConfig?.channelName ?? "";
    this.iosPlatformConfig?.channelType = iosPlatformConfig?.channelType ?? 0;
    this.iosPlatformConfig?.customDoc = iosPlatformConfig?.customDoc ?? "";
  }
}

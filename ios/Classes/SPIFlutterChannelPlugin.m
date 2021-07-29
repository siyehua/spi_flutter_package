#import "SPIFlutterChannelPlugin.h"
#import "MQQFlutterGen_ChannelManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SPIFlutterChannelPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [[MQQFlutterGen_ChannelManager sharedManager] initializeWithBinaryMessenger:[registrar messenger]];
}

@end

NS_ASSUME_NONNULL_END

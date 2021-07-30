#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import "SPIFlutterChannelPlugin.h"
#import "MQQFlutterGen_ChannelManager.h"
#import "MQQAccountImp.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [SPIFlutterChannelPlugin registerWithRegistrar:[self registrarForPlugin:@"SPIFlutterChannelPlugin"]];
    [[MQQFlutterGen_ChannelManager sharedManager] addMethodImplementation:[MQQAccountImp new] withName:NSStringFromProtocol(@protocol(MQQFlutterGen_IAccount))];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

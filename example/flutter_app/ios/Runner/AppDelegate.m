#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import "MQQFlutterGen_ChannelManager.h"
#import "MQQAccountImp.h"
#import "MQQFlutterGen_FpsImp.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [[MQQFlutterGen_ChannelManager sharedManager] initializeWithBinaryMessenger:[self registrarForPlugin:@"channelPlugin"].messenger];
    [[MQQFlutterGen_ChannelManager sharedManager] addMethodImplementation:[MQQAccountImp new] withName:NSStringFromProtocol(@protocol(MQQFlutterGen_IAccount))];
    
    [[MQQFlutterGen_FpsImp new] add11:11];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

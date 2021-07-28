#import "MQQFlutterGen_FpsImp.h"
#import "MQQFlutterGen_ChannelManager.h"
NS_ASSUME_NONNULL_BEGIN

@implementation MQQFlutterGen_FpsImp
- (void *)getPageName:(int )a callback:(MQQFlutterGen_Result<NSString *> *)callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:@(a)];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:getPageName args:args completion:callback];
}

- (void *)getFps:(MQQFlutterGen_Result<NSNumber *> *)callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:getFps args:args completion:callback];
}

- (void *)add11:(int )b
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:@(b)];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:add11 args:args completion:nil];
}

- (void *)getPage:(MQQFlutterGen_Result<MQQFlutterGen_PageInfo *> *)callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:getPage args:args completion:callback];
}

- (void *)getListCustom:(NSArray<MQQFlutterGen_InnerClass *> *)a callback:(MQQFlutterGen_Result<NSArray<MQQFlutterGen_PageInfo *> *> *)callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:a];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:getListCustom args:args completion:callback];
}

- (void *)getMapCustom:(MQQFlutterGen_Result<NSDictionary<MQQFlutterGen_PageInfo *, NSNumber *> *> *)callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:getMapCustom args:args completion:callback];
}

@end
NS_ASSUME_NONNULL_END

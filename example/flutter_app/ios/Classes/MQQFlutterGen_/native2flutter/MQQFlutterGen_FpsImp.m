#import "MQQFlutterGen_FpsImp.h"
#import "MQQFlutterGen_ChannelManager.h"
NS_ASSUME_NONNULL_BEGIN

@implementation MQQFlutterGen_FpsImp

/// Dart method declaraction:   Future<String> getPageName(int a)
/// @param a Agument a, type: dart.core.int.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getPageName:(long long )a callback:(void(^)(NSString *))callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:@(a)];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"getPageName" args:args fromClass:self.class completion:callback];
}


/// Dart method declaraction:   Future<double> getFps()
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getFps:(void(^)(NSNumber *))callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"getFps" args:args fromClass:self.class completion:callback];
}


/// Dart method declaraction:   void add11(int b)
/// @param b Agument b, type: dart.core.int.
- (void )add11:(long long )b
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:@(b)];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"add11" args:args fromClass:self.class completion:nil];
}


/// Dart method declaraction:   Future<PageInfo> getPage()
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getPage:(void(^)(MQQFlutterGen_PageInfo *))callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"getPage" args:args fromClass:self.class completion:callback];
}


/// Dart method declaraction:   Future<List<PageInfo>> getListCustom(List<int> a)
/// @param a Agument a, type: dart.core.List.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getListCustom:(NSArray<NSNumber *> *)a callback:(void(^)(NSArray<MQQFlutterGen_PageInfo *> *))callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:a];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"getListCustom" args:args fromClass:self.class completion:callback];
}


/// Dart method declaraction:   Future<Map<PageInfo, int>> getMapCustom()
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getMapCustom:(void(^)(NSDictionary<MQQFlutterGen_PageInfo *, NSNumber *> *))callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"getMapCustom" args:args fromClass:self.class completion:callback];
}

@end
NS_ASSUME_NONNULL_END

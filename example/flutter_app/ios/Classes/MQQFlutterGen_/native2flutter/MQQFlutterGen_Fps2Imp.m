#import "MQQFlutterGen_Fps2Imp.h"
#import "MQQFlutterGen_ChannelManager.h"
NS_ASSUME_NONNULL_BEGIN

@implementation MQQFlutterGen_Fps2Imp

/// Dart method declaraction:   Future<String> getPageName(Map<String, int> t, String t2)
/// @param t Agument t, type: dart.core.Map.
/// @param t2 Agument t2, type: dart.core.String.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getPageName:(NSDictionary<NSString *, NSNumber *> *)t t2:(NSString *)t2 callback:(void(^)(NSString *))callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:t];
	[args addObject:t2];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"getPageName" args:args completion:callback];
}


/// Dart method declaraction:   Future<double> getFps(String t, int a)
/// @param t Agument t, type: dart.core.String.
/// @param a Agument a, type: dart.core.int.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getFps:(NSString *)t a:(int )a callback:(void(^)(NSNumber *))callback
 {
	NSMutableArray *args = [NSMutableArray array];
	[args addObject:t];
	[args addObject:@(a)];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"getFps" args:args completion:callback];
}


/// Dart method declaraction:   void add23()
- (void )add23
 {
	NSMutableArray *args = [NSMutableArray array];
	[[MQQFlutterGen_ChannelManager sharedManager] invokeMethod:@"add23" args:args completion:nil];
}

@end
NS_ASSUME_NONNULL_END

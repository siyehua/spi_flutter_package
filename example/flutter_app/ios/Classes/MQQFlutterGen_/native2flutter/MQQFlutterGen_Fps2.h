#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol MQQFlutterGen_Fps2 <NSObject>
@required



/// Dart method declaraction:   Future<String> getPageName(Map<String, int> t, String t2);
/// @param t Agument t, type: dart.core.Map.
/// @param t2 Agument t2, type: dart.core.String.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getPageName:(NSDictionary<NSString *, NSNumber *> *)t t2:(NSString *)t2 callback:(void(^)(NSString *))callback;

/// Dart method declaraction:   Future<double> getFps(String t, int a);
/// @param t Agument t, type: dart.core.String.
/// @param a Agument a, type: dart.core.int.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getFps:(NSString *)t a:(long long )a callback:(void(^)(NSNumber *))callback;

/// Dart method declaraction:   void add23();
- (void )add23;

@end
NS_ASSUME_NONNULL_END
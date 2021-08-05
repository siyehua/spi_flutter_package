#import <Foundation/Foundation.h>

#import "MQQFlutterGen_PageInfo.h"
#import "MQQFlutterGen_InnerClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MQQFlutterGen_Fps <NSObject>
@optional



/// Dart method declaraction:   Future<String> getPageName(int a);
/// @param a Agument a, type: dart.core.int.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getPageName:(int )a callback:(void(^)(NSString *))callback;

/// Dart method declaraction:   Future<double> getFps();
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getFps:(void(^)(NSNumber *))callback;

/// Dart method declaraction:   void add11(int b);
/// @param b Agument b, type: dart.core.int.
- (void )add11:(int )b;

/// Dart method declaraction:   Future<PageInfo> getPage();
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getPage:(void(^)(MQQFlutterGen_PageInfo *))callback;

/// Dart method declaraction:   Future<List<PageInfo>> getListCustom(List<InnerClass> a);
/// @param a Agument a, type: dart.core.List.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getListCustom:(NSArray<MQQFlutterGen_InnerClass *> *)a callback:(void(^)(NSArray<MQQFlutterGen_PageInfo *> *))callback;

/// Dart method declaraction:   Future<Map<PageInfo, int>> getMapCustom();
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getMapCustom:(void(^)(NSDictionary<MQQFlutterGen_PageInfo *, NSNumber *> *))callback;

@end
NS_ASSUME_NONNULL_END
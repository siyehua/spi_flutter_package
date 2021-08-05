#import <Foundation/Foundation.h>

#import "MQQFlutterGen_InnerClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MQQFlutterGen_IAccount <NSObject>
@optional



/// Dart method declaraction:   Future<String?> login(String? name, Object password);
/// @param name Agument name, type: dart.core.String.
/// @param password Agument password, type: dart.core.Object.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )login:(nullable NSString *)name password:(id )password callback:(void(^)(NSString * _Nullable))callback;

/// Dart method declaraction:   Future<String?> getToken();
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getToken:(void(^)(NSString * _Nullable))callback;

/// Dart method declaraction:   void logout(InnerClass abc, List<InnerClass> list, List<List<Map<int, String>>> aaa);
/// @param abc Agument abc, type: .InnerClass.
/// @param list Agument list, type: dart.core.List.
/// @param aaa Agument aaa, type: dart.core.List.
- (void )logout:(MQQFlutterGen_InnerClass *)abc list:(NSArray<MQQFlutterGen_InnerClass *> *)list aaa:(NSArray<NSArray<NSDictionary<NSNumber *, NSString *> *> *> *)aaa;

/// Dart method declaraction:   Future<int> getAge();
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getAge:(void(^)(NSNumber *))callback;

/// Dart method declaraction:   Future<InnerClass> getAge2();
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getAge2:(void(^)(MQQFlutterGen_InnerClass *))callback;

/// Dart method declaraction:   Future<List<String>?> getList(InnerClass? abc);
/// @param abc Agument abc, type: .InnerClass.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getList:(nullable MQQFlutterGen_InnerClass *)abc callback:(void(^)(NSArray<NSString *> * _Nullable))callback;

/// Dart method declaraction:   Future<Map<List<String>?, InnerClass>> getMap();
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )getMap:(void(^)(NSDictionary<NSArray<NSString *> *, MQQFlutterGen_InnerClass *> *))callback;

/// Dart method declaraction:   void setMap(Map<int, bool>? a);
/// @param a Agument a, type: dart.core.Map.
- (void )setMap:(nullable NSDictionary<NSNumber *, NSNumber *> *)a;

/// Dart method declaraction:   Future<Map<int, bool>> all(List<int>? a, Map<String?, int> b, int? c);
/// @param a Agument a, type: dart.core.List.
/// @param b Agument b, type: dart.core.Map.
/// @param c Agument c, type: dart.core.int.
/// @param callback Agument callback, type: ChannelManager.Result.
- (void )all:(nullable NSArray<NSNumber *> *)a b:(NSDictionary<NSString *, NSNumber *> *)b c:(int )c callback:(void(^)(NSDictionary<NSNumber *, NSNumber *> *))callback;

@end
NS_ASSUME_NONNULL_END
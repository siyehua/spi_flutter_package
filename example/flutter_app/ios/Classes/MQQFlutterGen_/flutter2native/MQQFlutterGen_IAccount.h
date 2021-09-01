#import <Foundation/Foundation.h>

#import "MQQFlutterGen_InnerClass.h"
#import "MQQFlutterGen_InnerClass _Nullable.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MQQFlutterGen_IAccount <NSObject>
@optional


- (void )login:(nullable NSString *)name password:(id )password callback:(void(^)(NSString * _Nullable))callback;
- (void )getToken:(void(^)(NSString * _Nullable))callback;
- (void )logout:(MQQFlutterGen_InnerClass *)abc list:(NSArray<MQQFlutterGen_InnerClass *> *)list aaa:(NSArray<NSArray<NSDictionary<NSNumber *, NSString *> *> *> *)aaa;
- (void )getAge:(void(^)(NSNumber *))callback;
- (void )getAge2:(void(^)(MQQFlutterGen_InnerClass * _Nullable))callback;
- (void )getList:(nullable MQQFlutterGen_InnerClass *)abc callback:(void(^)(NSArray<NSString *> * _Nullable))callback;
- (void )getMap:(void(^)(NSDictionary<NSArray<NSString *> *, MQQFlutterGen_InnerClass *> *))callback;
- (void )setMap:(nullable NSDictionary<NSNumber *, NSNumber *> *)a;
- (void )all:(nullable NSArray<NSNumber *> *)a b:(NSDictionary<NSString *, NSNumber *> *)b c:(int )c callback:(void(^)(NSDictionary<NSNumber *, NSNumber *> *))callback;

@end
NS_ASSUME_NONNULL_END
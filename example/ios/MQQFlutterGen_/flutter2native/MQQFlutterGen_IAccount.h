#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MQQFlutterGen_IAccount <NSObject>
@optional


- (void *)login:(nullable NSString *)name password:(MQQFlutterGen_Object *)password callback:(void(^)(NSString * _Nullable))callback;
- (void *)getToken:(void(^)(NSString * _Nullable))callback;
- (void *)logout:(MQQFlutterGen_InnerClass *)abc list:(NSArray<MQQFlutterGen_InnerClass *> *)list aaa:(NSArray<NSArray<NSDictionary<NSNumber *, NSString *> *> *> *)aaa;
- (void *)getAge:(void(^)(NSNumber *))callback;
- (void *)getList:(nullable MQQFlutterGen_InnerClass *)abc callback:(void(^)(NSArray<NSString *> * _Nullable))callback;
- (void *)getMap:(void(^)(NSDictionary<NSArray<NSString *> *, MQQFlutterGen_InnerClass *> *))callback;
- (void *)setMap:(nullable NSDictionary<NSNumber *, NSNumber *> *)a;
- (void *)all:(nullable NSArray<NSNumber *> *)a b:(NSDictionary<NSString *, NSNumber *> *)b c:(int )c callback:(void(^)(NSDictionary<NSNumber *, NSNumber *> *))callback;

@end
NS_ASSUME_NONNULL_END
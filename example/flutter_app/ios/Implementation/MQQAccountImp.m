//
//  MQQAccountImp.m
//  Runner
//
//  Created by Wei Du on 2021/7/30.
//

#import "MQQAccountImp.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MQQAccountImp

- (void )login:(nullable NSString *)name password:(id )password callback:(void(^)(NSString * _Nullable))callback
{
    NSLog(@"call login, name: %@, password: %@", name, password);
    dispatch_async(dispatch_get_main_queue(), ^{
        callback([NSString stringWithFormat:@"login callback, name: %@, password: %@", name, password]);
    });
}

- (void )getToken:(void(^)(NSString * _Nullable))callback
{
    NSLog(@"call get token");
    dispatch_async(dispatch_get_main_queue(), ^{
        callback(@"get token callback");
    });
}

- (void )logout:(MQQFlutterGen_InnerClass *)abc list:(NSArray<MQQFlutterGen_InnerClass *> *)list aaa:(NSArray<NSArray<NSDictionary<NSNumber *, NSString *> *> *> *)aaa
{
    NSLog(@"call logout, abc: %@, list: %@, aaa: %@", abc, list, aaa);
}

- (void )getAge:(void(^)(NSNumber *))callback
{
    NSLog(@"call get age");
    callback(@(10));
}

- (void )getAge2:(void(^)(MQQFlutterGen_InnerClass *))callback
{
    NSLog(@"call get age2");
    dispatch_async(dispatch_get_main_queue(), ^{
        callback([MQQFlutterGen_InnerClass new]);
    });
}

- (void )getList:(nullable MQQFlutterGen_InnerClass *)abc callback:(void(^)(NSArray<NSString *> * _Nullable))callback
{
    NSLog(@"call get list, abc: %@", abc);
    callback(@[[NSString stringWithFormat:@"get list call back, abc: %@", abc]]);
}

- (void )getMap:(void(^)(NSDictionary<NSArray<NSString *> *, MQQFlutterGen_InnerClass *> *))callback
{
    NSLog(@"call get map");
    dispatch_async(dispatch_get_main_queue(), ^{
        callback(@{@[@"test"]: [MQQFlutterGen_InnerClass new]});
    });
}

- (void )setMap:(nullable NSDictionary<NSNumber *, NSNumber *> *)a
{
    NSLog(@"call set map, %@", a);
}

- (void )all:(nullable NSArray<NSNumber *> *)a b:(NSDictionary<NSString *, NSNumber *> *)b c:(int )c callback:(void(^)(NSDictionary<NSNumber *, NSNumber *> *))callback
{
    NSLog(@"call all, a: %@, b: %@, c: %d", a, b, c);
    callback(@{@1: @YES});
}

@end

NS_ASSUME_NONNULL_END

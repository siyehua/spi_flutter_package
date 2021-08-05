#import <Foundation/Foundation.h>

#import "MQQFlutterGen_PageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MQQFlutterGen_Fps <NSObject>
@optional


- (void )getPageName:(int )a callback:(void(^)(NSString *))callback;
- (void )getFps:(void(^)(NSNumber *))callback;
- (void )add11:(int )b;
- (void )getPage:(void(^)(MQQFlutterGen_PageInfo *))callback;
- (void )getListCustom:(NSArray<NSNumber *> *)a callback:(void(^)(NSArray<MQQFlutterGen_PageInfo *> *))callback;
- (void )getMapCustom:(void(^)(NSDictionary<MQQFlutterGen_PageInfo *, NSNumber *> *))callback;

@end
NS_ASSUME_NONNULL_END
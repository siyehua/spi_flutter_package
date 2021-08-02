#import "MQQFlutterGen_PageInfo.h"

NS_ASSUME_NONNULL_BEGIN
@implementation MQQFlutterGen_PageInfo
- (instancetype)init
{
	self = [super init];
	if (self) {
		self.fps = 0.0;

	}
	return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
	MQQFlutterGen_PageInfo *value = [[self.class allocWithZone:zone] init];
	value.name = _name;
	value.id = _id;
	value.fps = _fps;
	return value;
}

@end
NS_ASSUME_NONNULL_END
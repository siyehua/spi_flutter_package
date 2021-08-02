#import "MQQFlutterGen_Route.h"

NS_ASSUME_NONNULL_BEGIN
@implementation MQQFlutterGen_Route
- (instancetype)init
{
	self = [super init];
	if (self) {
		self.main_page = @"/main/page";
		self.mine_main = @"/mine/main";
		self.int_value = 123;

	}
	return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
	MQQFlutterGen_Route *value = [[self.class allocWithZone:zone] init];
	value.main_page = _main_page;
	value.mine_main = _mine_main;
	value.int_value = _int_value;
	return value;
}

@end
NS_ASSUME_NONNULL_END
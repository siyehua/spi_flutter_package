#import "MQQFlutterGen_MyClass.h"

NS_ASSUME_NONNULL_BEGIN
@implementation MQQFlutterGen_MyClass
- (instancetype)init
{
	self = [super init];
	if (self) {
		self.b = 0;
		self.d = @"default";
		self.g1 = [NSArray array];
		self.g2 = [NSArray arrayWithObjects:@1, @2, @3, @4, nil];
		self.j1 = [NSArray array];
		self.j2 = [NSArray arrayWithObjects:[MQQFlutterGen_InnerClass new], [MQQFlutterGen_InnerClass new], nil];
		self.i1 = [NSDictionary dictionary];
		self.i2 = @{@"key": @1, @"key2": @2};
		self.i5 = @{[MQQFlutterGen_InnerClass new]: [MQQFlutterGen_InnerClass new]};

	}
	return self;
}


@end
NS_ASSUME_NONNULL_END
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

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
	MQQFlutterGen_MyClass *value = [[self.class allocWithZone:zone] init];
	value.abc = _abc;
	value.aaa = _aaa;
	value.a = _a;
	value.b = _b;
	value.c = _c;
	value.d = _d;
	value.g = _g;
	value.g1 = _g1;
	value.g2 = _g2;
	value.j = _j;
	value.j1 = _j1;
	value.j2 = _j2;
	value.i = _i;
	value.i1 = _i1;
	value.i2 = _i2;
	value.i3 = _i3;
	value.i4 = _i4;
	value.i5 = _i5;
	return value;
}

@end
NS_ASSUME_NONNULL_END
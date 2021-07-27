String objcChannelInterfaceString = '''
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQQFlutterChannelManager : NSObject

/// initialize channel manager
/// @param engine the flutter engine
- (void)initializeWithFlutterEngine:(FlutterEngine *)engine;

/// add an native implementation for a dart generated protocol
/// dart code with abstract methods will generated into a objc protocol
/// native implementation should conform to the generated protocol and implment
/// those abstract method.
/// @param implementation the native implementation class instance.
/// @param name the generated protocol name.
- (void)addMethodImplementation:(id)implementation withName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
''';

String objcChannelImplementationString = '''
#import "MQQFlutterChannelManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MQQFlutterChannelManager ()

@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *methodImplementations;

@end

@implementation MQQFlutterChannelManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.channelName = @"com.example.channelname";
        self.methodImplementations = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Methods

- (void)initializeWithFlutterEngine:(FlutterEngine *)engine
{
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:self.channelName binaryMessenger:engine.binaryMessenger];
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSArray *methodSubstring = [call.method componentsSeparatedByString:@"#"];
        if (methodSubstring.count < 2) {
            return;
        }
        NSString *callClass = methodSubstring[0];
        NSString *callMethod = methodSubstring[1];
        if (callClass.length > 0) {
            id implementation = self.methodImplementations[callClass];
            if (implementation && [implementation respondsToSelector:NSSelectorFromString(callMethod)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [implementation performSelector:NSSelectorFromString(callMethod) withObject:call.arguments];
            }
#pragma clang diagnostic pop
        }

    }];
}

- (void)addMethodImplementation:(id)implementation withName:(NSString *)name
{
    self.methodImplementations[name] = implementation;
}

@end

NS_ASSUME_NONNULL_END
''';

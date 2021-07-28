String objcChannelInterfaceString = '''
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface #{projectPrefix}ChannelManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong, nullable) FlutterMethodChannel *methodChannel;

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

/// Invoke a dart method
/// @param method the method's name
/// @param args the method's arguments
/// @param completion the method's completion result
- (void)invokeMethod:(NSString *)method args:(nullable NSArray *)args completion:(nullable void(^)(__nullable id result))completion;

@end

NS_ASSUME_NONNULL_END
''';

String objcChannelImplementationString = '''
#import "FlutterChannelManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface #{projectPrefix}ChannelManager ()

@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, strong, nullable) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *methodImplementations;

@end

@implementation #{projectPrefix}ChannelManager

+ (instancetype)sharedManager
{
    static #{projectPrefix}ChannelManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.channelName = @"com.siyehua.spiexample.channel";
        self.methodImplementations = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Methods

- (void)initializeWithFlutterEngine:(FlutterEngine *)engine
{
    __weak typeof(self) weakSelf = self;
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:self.channelName binaryMessenger:engine.binaryMessenger];
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSArray *methodSubstring = [call.method componentsSeparatedByString:@"#"];
        if (methodSubstring.count < 2) {
            return;
        }
        NSString *callClass = methodSubstring[0];
        NSString *callMethod = methodSubstring[1];
        if (callClass.length > 0) {
            id implementation = weakSelf.methodImplementations[callClass];
            if (implementation && [implementation respondsToSelector:NSSelectorFromString(callMethod)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [implementation performSelector:NSSelectorFromString(callMethod) withObject:call.arguments];
            } else {
                result(FlutterMethodNotImplemented);
            }
#pragma clang diagnostic pop
        }

    }];
}

- (void)addMethodImplementation:(id)implementation withName:(NSString *)name
{
    self.methodImplementations[name] = implementation;
}

- (void)invokeMethod:(NSString *)method args:(nullable NSArray *)args completion:(nullable void(^)(__nullable id result))completion
{
    [self.methodChannel invokeMethod:method arguments:args result:^(id  _Nullable result) {
        if (completion) {
            completion(result);
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
''';

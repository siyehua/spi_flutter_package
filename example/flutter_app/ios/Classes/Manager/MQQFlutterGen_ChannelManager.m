#import "MQQFlutterGen_ChannelManager.h"

#if defined(__has_include) && __has_include("MJExtension.h")
#import "MJExtension.h"
#else
#import <MJExtension/MJExtension.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MQQFlutterGen_ChannelManager ()

@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, strong, nullable) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *methodImplementations;

@end

@implementation MQQFlutterGen_ChannelManager

+ (instancetype)sharedManager
{
    static MQQFlutterGen_ChannelManager *manager;
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

- (void)initializeWithBinaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
    __weak typeof(self) weakSelf = self;
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:self.channelName binaryMessenger:messenger];
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSArray *methodSubstring = [call.method componentsSeparatedByString:@"#"];
        if (methodSubstring.count < 3) {
            result(FlutterMethodNotImplemented);
            return;
        }
        NSString *callClassString = methodSubstring[0];
        NSString *callClass = [NSString stringWithFormat:@"MQQFlutterGen_%@", [callClassString componentsSeparatedByString:@"."].lastObject];
        NSString *callMethod = methodSubstring[1];
        NSArray *arguments = [methodSubstring[2] componentsSeparatedByString:@","];
        // assemble method name with arguments name
        for (NSString *argument in arguments) {
            if ([argument isEqualToString:arguments.firstObject]) {
                callMethod = [callMethod stringByAppendingString:@":"];
            } else {
                callMethod = [callMethod stringByAppendingFormat:@"%@:", argument];
            }
        }
        if (callClass.length > 0) {
            id implementation = weakSelf.methodImplementations[callClass];
            if (implementation && [implementation respondsToSelector:NSSelectorFromString(callMethod)]) {
                // generate method invocation
                SEL selector = NSSelectorFromString(callMethod);
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[implementation methodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:implementation];
                [call.arguments enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    id arg = obj;
                    if ([obj isKindOfClass:[NSString class]]) {
                        NSString *string = (NSString *)obj;
                        if ([string containsString:@"___custom___"]) {    // generate custom class initilize
                            NSString *className = [NSString stringWithFormat:@"MQQFlutterGen_%@", [string substringToIndex:[string rangeOfString:@"___custom___"].location]];
                            NSInteger propertiesBegin = [string rangeOfString:@"{"].location;
                            Class customClass = NSClassFromString(className);
                            arg = [customClass new];
                            if (propertiesBegin != NSNotFound) {
                                NSString *properties = [string substringWithRange:NSMakeRange(propertiesBegin, string.length - propertiesBegin)];
                                NSData *data = [properties dataUsingEncoding:NSUTF8StringEncoding];
                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                for (NSString *key in json.allKeys) {
                                    [arg setValue:json[key] forKey:key];    // perform setter method
                                }
                            }
                        }
                    }
                    [invocation setArgument:&(arg) atIndex:idx + 2];
                    [invocation retainArguments];
                }];
                void(^completion)(id _Nullable object) = ^(id _Nullable object) {
                    object = [self _convertCustomClass:object];
                    result(object);
                };
                [invocation setArgument:&(completion) atIndex:arguments.count + 1];
                [invocation invoke];
            } else {
                result(FlutterMethodNotImplemented);
            }
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

#pragma mark - Private Methods

- (id)_convertCustomClass:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray array];
        for (id value in (NSArray *)object) {
            [array addObject:[self _convertCustomClass:value]];
        }
        return array;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [((NSDictionary *)object) enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            dict[[self _convertCustomClass:key]] = [self _convertCustomClass:obj];
        }];
        return dict;
    } else if ([NSStringFromClass([object class]) hasPrefix:@"MQQFlutterGen_"]) {
        // custom class
        NSString *className = [NSStringFromClass([object class]) stringByReplacingOccurrencesOfString:@"MQQFlutterGen_" withString:@""];
        NSString *properties = ((NSObject *)object).mj_JSONString;
        return [NSString stringWithFormat:@"%@___custom___%@", className, properties];
    }
    return object;
}

@end

NS_ASSUME_NONNULL_END

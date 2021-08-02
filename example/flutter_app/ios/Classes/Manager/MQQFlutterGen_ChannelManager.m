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
                    id arg = [weakSelf _convertObjectToCustomObjectIfNeeded:obj];
                    [invocation setArgument:&(arg) atIndex:idx + 2];
                    [invocation retainArguments];
                }];
                BOOL hasCallback = [arguments containsObject:@"callback"];
                if (hasCallback) {
                    void(^completion)(id _Nullable object) = ^(id _Nullable object) {
                        object = [weakSelf _convertCustomClassToStringIfNeeded:object];
                        result(object);
                    };
                    [invocation setArgument:&(completion) atIndex:arguments.count + 1];
                    [invocation retainArguments];
                }
                [invocation invoke];
                if (!hasCallback) {
                    result(@YES);
                }
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

- (id)_convertCustomClassToStringIfNeeded:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray array];
        for (id value in (NSArray *)object) {
            [array addObject:[self _convertCustomClassToStringIfNeeded:value]];
        }
        return array;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [((NSDictionary *)object) enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            dict[[self _convertCustomClassToStringIfNeeded:key]] = [self _convertCustomClassToStringIfNeeded:obj];
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

- (id)_convertObjectToCustomObjectIfNeeded:(id)object
{
    id arg = object;
    if ([object isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)object;
        // custom class in flutter will convert into string like: '___custom___"className"{"properties"}'
        if ([string containsString:@"___custom___"]) {
            NSString *className = [NSString stringWithFormat:@"MQQFlutterGen_%@", [string substringToIndex:[string rangeOfString:@"___custom___"].location]];
            NSInteger propertiesBegin = [string rangeOfString:@"{"].location;
            Class customClass = NSClassFromString(className);
            arg = [customClass new];
            if (propertiesBegin != NSNotFound) {
                // get properties
                NSString *properties = [string substringWithRange:NSMakeRange(propertiesBegin, string.length - propertiesBegin)];
                NSData *data = [properties dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                for (NSString *key in json.allKeys) {
                    [arg setValue:json[key] forKey:key];    // perform setter method
                }
            }
        }
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray array];
        for (id value in (NSArray *)object) {
            [array addObject:[self _convertObjectToCustomObjectIfNeeded:value]];
        }
        return array;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            dict[[self _convertObjectToCustomObjectIfNeeded:key]] = [self _convertObjectToCustomObjectIfNeeded:obj];
        }];
        return dict;
    }
    return arg;
}


@end

NS_ASSUME_NONNULL_END

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
        if ([weakSelf.delegate respondsToSelector:@selector(manager:didReceviceMethodCall:)]) {
            [weakSelf.delegate manager:weakSelf didReceviceMethodCall:call];
        }
        NSArray *methodSubstring = [call.method componentsSeparatedByString:@"#"];
        if (methodSubstring.count < 3) {
            result(FlutterMethodNotImplemented);
            [weakSelf _handleMethodCall:call success:NO];
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
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        NSInteger value = [obj integerValue];
                        [invocation setArgument:&value atIndex:idx + 2];
                    } else {
                        id arg = [weakSelf _convertObjectToNativeReadableIfNeeded:obj];
                        [invocation setArgument:&(arg) atIndex:idx + 2];
                        [invocation retainArguments];
                    } 
                }];
                BOOL hasCallback = [arguments containsObject:@"callback"];
                if (hasCallback) {
                    void(^completion)(id _Nullable object) = ^(id _Nullable object) {
                        object = [weakSelf _convertClassToFlutterReadableIfNeeded:object];
                        result(object);
                    };
                    [invocation setArgument:&(completion) atIndex:arguments.count + 1];
                    [invocation retainArguments];
                }
                [invocation invoke];
                if (!hasCallback) {
                    result(@YES);
                    [weakSelf _handleMethodCall:call success:YES];
                }
            } else {
                result(FlutterMethodNotImplemented);
                [weakSelf _handleMethodCall:call success:NO];
            }
        }

    }];
}

- (void)addMethodImplementation:(id)implementation withName:(NSString *)name
{
    self.methodImplementations[name] = implementation;
}

- (void)invokeMethod:(NSString *)method args:(nullable NSArray *)args fromClass:(Class)classType completion:(nullable void(^)(__nullable id result))completion
{
    NSString *methodString = self.channelName;
    NSString *protocolName = [NSStringFromClass(classType) stringByReplacingOccurrencesOfString:@"Imp" withString:@""];
    protocolName = [protocolName stringByReplacingOccurrencesOfString:@"MQQFlutterGen_" withString:@""];
    methodString = [methodString stringByAppendingFormat:@".%@", protocolName];
    methodString = [methodString stringByAppendingFormat:@"#%@", method];
    [self.methodChannel invokeMethod:methodString arguments:args result:^(id  _Nullable result) {
        if (completion) {
            completion(result);
        }
    }];
}


#pragma mark - Private Methods

/// Convert custom class into flutter readable class.
/// Custom class can not pass through method channel without messages codec,
/// so we convert custom class into string, then dart side will convert it back to class,
/// this custom class transformation will later be replaced by messages codec.
/// @param object The object needs to convert
- (id)_convertClassToFlutterReadableIfNeeded:(nullable id)object
{
    if (!object) {
        return [NSNull null];
    }
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray array];
        for (id value in (NSArray *)object) {
            [array addObject:[self _convertClassToFlutterReadableIfNeeded:value]];
        }
        return array;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [((NSDictionary *)object) enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            dict[[self _convertClassToFlutterReadableIfNeeded:key]] = [self _convertClassToFlutterReadableIfNeeded:obj];
        }];
        return dict;
    } else if ([NSStringFromClass([object class]) hasPrefix:@"MQQFlutterGen_"]) {
        // custom class
        NSString *className = [NSStringFromClass([object class]) stringByReplacingOccurrencesOfString:@"MQQFlutterGen_" withString:@""];
        NSString *properties = ((NSObject *)object).mj_JSONString;
        return [NSString stringWithFormat:@"%@___custom___%@", className, properties];
    } else if ([object isKindOfClass:[NSData class]]) {
        return [FlutterStandardTypedData typedDataWithBytes:(NSData *)object];
    }
    return object;
}

/// Convert a object into native readable class
/// custom class can not pass through method channel without messages codec,
/// so dart side convert custom class into string, then native side will convert it back to class,
/// this custom class transformation will later be replaced by messages codec.
/// @param object The object needs to convert
- (nullable id)_convertObjectToNativeReadableIfNeeded:(id)object
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
            [array addObject:[self _convertObjectToNativeReadableIfNeeded:value]];
        }
        return array;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            dict[[self _convertObjectToNativeReadableIfNeeded:key]] = [self _convertObjectToNativeReadableIfNeeded:obj];
        }];
        return dict;
    } else if ([object isKindOfClass:[FlutterStandardTypedData class]]) {
        return [(FlutterStandardTypedData *)object data];
    } else if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return arg;
}

- (void)_handleMethodCall:(FlutterMethodCall *)methodCall success:(BOOL)success
{
    if ([self.delegate respondsToSelector:@selector(manager:didHandleMethodCall:success:)]) {
        [self.delegate manager:self didHandleMethodCall:methodCall success:success];
    }
}

@end

NS_ASSUME_NONNULL_END

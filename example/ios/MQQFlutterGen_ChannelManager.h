#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQQFlutterGen_ChannelManager : NSObject

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

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@class MQQFlutterGen_ChannelManager;

/// Protocol for channel manager method call
@protocol MQQFlutterGen_ChannelManagerDelegate <NSObject>

- (void)manager:(MQQFlutterGen_ChannelManager *)manager didReceviceMethodCall:(FlutterMethodCall *)methodCall;
- (void)manager:(MQQFlutterGen_ChannelManager *)manager didHandleMethodCall:(FlutterMethodCall *)methodCall success:(BOOL)success;

@end

@interface MQQFlutterGen_ChannelManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) FlutterMethodChannel *methodChannel;

@property (nonatomic, weak, nullable) id<MQQFlutterGen_ChannelManagerDelegate> delegate;

/// initialize channel manager
/// @param messenger The binary messenger.
- (void)initializeWithBinaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

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
/// @param class caller's classType
/// @param completion the method's completion result
- (void)invokeMethod:(NSString *)method args:(nullable NSArray *)args fromClass:(Class)classType completion:(nullable void(^)(__nullable id result))completion;

@end

NS_ASSUME_NONNULL_END

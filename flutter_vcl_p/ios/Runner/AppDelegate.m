#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@interface AppDelegate()
@property(nonnull, strong) FlutterMethodChannel *sdkChannel;
@property(nonnull, strong) FlutterMethodChannel *sdkCallbacksChannel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    FlutterViewController *controller = (FlutterViewController*)self.window.rootViewController;
    
    // Override point for customization after application launch.
    _sdkChannel = [FlutterMethodChannel methodChannelWithName:@"com.vungle.vcltool/sdk"
                                              binaryMessenger:controller];
    
    _sdkCallbacksChannel = [FlutterMethodChannel methodChannelWithName:@"com.vungle.vcltool/sdkCallbacks"
                                              binaryMessenger:controller];
    
    __weak typeof(self) weakSelf = self;
    
    
    [_sdkChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if([@"start" isEqualToString:call.method]) {
            NSLog(@"call start with args:%@", call.arguments);
            NSString *appId = (NSString*)call.arguments;
            NSError *error = nil;
            BOOL ret = [weakSelf startSDKWithAppId:appId error:&error];
            NSMutableDictionary *res = [NSMutableDictionary dictionary];
            res[@"return"] = @(ret);
            if (error != nil) {
                res[@"errorCode"] = @(error.code);
                res[@"errMsg"] = error.localizedDescription;
            }
            result(res);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)startSDKWithAppId:(NSString *)appId error:(NSError**)error{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //mock the start callback
        [_sdkCallbacksChannel invokeMethod:@"start" arguments:@{@"error":@"some error happend!"}];
    });
    return YES;
}


@end

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "FlutterMediator.h"
#import "AppInitializer.h"
#import "AppConfig.h"
#import "VungleSDKMediator.h"

@interface AppDelegate()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AppInitializer sharedInstance] start];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    FlutterViewController *controller = (FlutterViewController*)self.window.rootViewController;
    [[FlutterMediator sharedInstance] startWithFlutterViewController:controller];
    [[VungleSDKMediator sharedInstance] startWithFlutterViewController:controller];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


@end

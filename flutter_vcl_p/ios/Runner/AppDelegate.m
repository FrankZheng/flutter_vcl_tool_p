#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "FlutterMediator.h"
#include "AppInitializer.h"
#include "AppConfig.h"

@interface AppDelegate()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [[AppInitializer sharedInstance] start];
    
    
    FlutterViewController *controller = (FlutterViewController*)self.window.rootViewController;
    [[FlutterMediator sharedInstance] startWithFlutterViewController:controller];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


@end

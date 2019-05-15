//
//  SDKManagerProxy.m
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/4.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import "SDKManagerProxy.h"
#import "AppConfig.h"

@interface SDKManagerProxy()
@property(nonatomic, strong) NSDictionary *sdkVersionDict;
@end


@implementation SDKManagerProxy

+ (instancetype)sharedProxy {
    static SDKManagerProxy *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDKManagerProxy alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sdkVersionDict = @{
                            @"6.3.2": @"SDKManager_Vungle632.framework",
                            @"5.3.2": @"SDKManager_Vungle532.framework"
                            };
    }
    
    return self;
}

- (BOOL)load:(NSString *)sdkVersion {
#if 1
    NSString *frameworkName = _sdkVersionDict[sdkVersion];
#else
    NSString *frameworkName = @"SDKManager.framework";
#endif
    
    NSString *path = [_sdksFolderPath stringByAppendingPathComponent:frameworkName];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if(!bundle) {
        NSLog(@"%@ not found", path);
        return NO;
    }
    
    NSError *error = nil;
    if(![bundle loadAndReturnError:&error]) {
        NSLog(@"Load %@ failed: %@", frameworkName, error);
        return NO;
    } else {
        NSLog(@"Load %@ success", frameworkName);
    }
    
    Class clazz = NSClassFromString(@"SDKManager");
    _sdkManager = [clazz sharedManager];
    
    return YES;
}


@end

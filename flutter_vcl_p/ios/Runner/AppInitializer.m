//
//  AppInitializer.m
//  CreativeToolApp
//
//  Created by frank.zheng on 2019/3/29.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import "AppInitializer.h"
#import "WebServer.h"
#import "ResourceManager.h"
#import "SDKManagerProxy.h"
#import "LogViewModel.h"
#import "AppConfig.h"


@interface AppInitializer()
@property(nonatomic, strong) NSMutableArray *delegates;
@end


@implementation AppInitializer

+ (instancetype)sharedInstance {
    static AppInitializer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppInitializer alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegates = [NSMutableArray array];
    }
    return self;
}

- (void)addDelegate:(id<AppInitializerDelegate>)delegate {
    NSValue *value = [NSValue valueWithNonretainedObject:delegate];
    [_delegates addObject:value];
}

- (void)start {
    AppConfig *config = [AppConfig sharedConfig];
    [config setup];
    
    ResourceManager *resourceManager = [ResourceManager sharedInstance];
    [resourceManager setup];
    
    WebServer *webServer = [WebServer sharedInstance];
    webServer.webStaticFolderPath = resourceManager.webStaticFolderPath;
    webServer.webUploadFolderPath = resourceManager.webUploadFolderPath;
    [webServer setup];
    
    SDKManagerProxy *proxy = [SDKManagerProxy sharedProxy];
    proxy.sdksFolderPath = resourceManager.sdksFolderPath;
    [proxy load:[config currentSdkVersion]];
    
    
    id<SDKManagerProtocol> sdkManager = [SDKManagerProxy sharedProxy].sdkManager;
    sdkManager.serverURL = webServer.serverURL;
    sdkManager.appId = [AppConfig appId];
    sdkManager.placementId = [AppConfig placementId];
    sdkManager.networkLoggingEnabled = YES;
    
    //initialize log model
    LogViewModel *model = [LogViewModel sharedInstance];
    [sdkManager addDelegate:model];
    model.jsLogsFolderPath = resourceManager.jsLogsFolderPath;
    [model loadLogs];
    
    _initialized = YES;
    for(NSValue *value in _delegates) {
        id<AppInitializerDelegate> delegate = [value nonretainedObjectValue];
        if(delegate != nil) {
            [delegate appDidInitialize];
        }
    }
    
    //initialize sdk now
    [sdkManager start];
}



@end

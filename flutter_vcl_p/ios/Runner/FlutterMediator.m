//
//  FlutterMediator.m
//  Runner
//
//  Created by frank.zheng on 2019/5/15.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
#import "FlutterMediator.h"
#import "WebServer.h"
#import "AppConfig.h"
#import "LogViewModel.h"
#import "SDKManagerProxy.h"
#import "SDKManagerProtocol.h"
#import "ResourceManager.h"
#import "JSLog.h"
#import "JSError.h"
#import "JSTrace.h"
#import "SDKLog.h"
#import "LogItem.h"



#define kSDKChan @"com.vungle.vcltool/sdk"
#define kLoadAd @"loadAd"
#define kPlayAd @"playAd"
#define kForceCloseAd @"forceCloseAd"

#define kSDKCallbackChan @"com.vungle.vcltool/sdkCallbacks"
#define kAdLoaded @"adLoaded"
#define kAdDidPlay @"adDidPlay"
#define kAdDidClose @"adDidClose"

#define kWebServerChan @"com.vungle.vcltool/webserver"
#define kEndcardName @"endCardName"
#define kServerURL @"serverURL"

#define kWebServerCallbackChan @"com.vungle.vcltool/webserverCallbacks"
#define kEndcardUploaded @"endcardUploaded"

#define kAppConfigChan @"com.vungle.vcltool/appConfig"

#define kLogModelChan @"com.vungle.vcltool/logModel"
#define kLogs @"logs"
#define kClearLogs @"clearLogs"

#define kLogModelCallbackChan @"com.vungle.vcltool/logModelCallback"
#define kNewLogs @"newLogs"


@interface FlutterMediator() <SDKDelegate, WebServerDelegate, LogViewModelDelegate>
@property(nonnull, strong) FlutterViewController *controller;
@property(nonnull, strong) FlutterMethodChannel *sdkChan;
@property(nonnull, strong) FlutterMethodChannel *sdkCallbackChan;
@property(nonnull, strong) FlutterMethodChannel *webServerChan;
@property(nonnull, strong) FlutterMethodChannel *webServerCallbackChan;
@property(nonnull, strong) FlutterMethodChannel *appConfigChan;
@property(nonnull, strong) FlutterMethodChannel *logModelChan;
@property(nonnull, strong) FlutterMethodChannel *logModelCallbackChan;

@property(nonnull, strong) AppConfig* appConfig;
@property(nonnull, strong) LogViewModel* logModel;
@property(nonnull, strong) id<SDKManagerProtocol> sdkManager;
@property(nonnull, strong) WebServer* webServer;
@property(nonnull, strong) ResourceManager *resourceManager;



@end


@implementation FlutterMediator

+ (instancetype)sharedInstance {
    static FlutterMediator* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FlutterMediator alloc] init];
    });
    return instance;
}


- (void)startWithFlutterViewController:(FlutterViewController*)vc {
    _controller = vc;
    
    __weak typeof(self) weakSelf = self;
    
    _sdkManager = [SDKManagerProxy sharedProxy].sdkManager;
    [_sdkManager addDelegate:self];
    
    _webServer = [WebServer sharedInstance];
    [_webServer setDelegate:self];
    
    _logModel = [LogViewModel sharedInstance];
    _logModel.delegate = self;
    _appConfig = [AppConfig sharedConfig];
    _resourceManager = [ResourceManager sharedInstance];
    
    //register method channels:
    //1.sdk manager - methods / callbacks
    //2.web server - methods / callbacks
    //3.app config - methods
    //4.log view model - methods / callbacks
    _sdkChan = [FlutterMethodChannel methodChannelWithName:kSDKChan binaryMessenger:_controller];
    [_sdkChan setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [weakSelf handleSDKMethods:call result:result];
    }];
    _sdkCallbackChan = [FlutterMethodChannel methodChannelWithName:kSDKCallbackChan binaryMessenger:_controller];
    
    _webServerChan = [FlutterMethodChannel methodChannelWithName:kWebServerChan binaryMessenger:_controller];
    [_webServerChan setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [weakSelf handleWebServerMethods:call result:result];
    }];
    _webServerCallbackChan = [FlutterMethodChannel methodChannelWithName:kWebServerCallbackChan binaryMessenger:_controller];
    
    _appConfigChan = [FlutterMethodChannel methodChannelWithName:kAppConfigChan binaryMessenger:_controller];
    [_appConfigChan setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [weakSelf handleAppConfigMethods:call result:result];
    }];
    
    _logModelChan = [FlutterMethodChannel methodChannelWithName:kLogModelChan binaryMessenger:_controller];
    [_logModelChan setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [weakSelf handleLogModelMethods:call result:result];
    }];
    _logModelCallbackChan = [FlutterMethodChannel methodChannelWithName:kLogModelCallbackChan binaryMessenger:_controller];
}

- (void)handleSDKMethods:(FlutterMethodCall *)call result:(FlutterResult)result {
    if([kLoadAd isEqualToString:call.method]) {
        [_sdkManager loadAd];
    } else if([kPlayAd isEqualToString:call.method]) {
        [_sdkManager playAd:_controller enableCORs:[_appConfig isCORsEnabled]];
    } else if([kForceCloseAd isEqualToString:call.method]) {
        [_sdkManager forceCloseAd];
    } else {
        result(FlutterMethodNotImplemented);
        return;
    }
    result(@(YES));
}

- (void)handleWebServerMethods:(FlutterMethodCall *)call result:(FlutterResult)result {
    if([kServerURL isEqualToString:call.method]) {
        NSURL *url = _webServer.serverURL;
        result( url != nil ? url.absoluteString : @"");
    } else if([kEndcardName isEqualToString:call.method]) {
        NSArray<NSString*> *names = _resourceManager.uploadEndcardNames;
        if(names.count > 0) {
            result(names[0]);
        } else {
            result(nil);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleAppConfigMethods:(FlutterMethodCall *)call result:(FlutterResult)result {
    
}

- (void)handleLogModelMethods:(FlutterMethodCall *)call result:(FlutterResult)result {
    if([kLogs isEqualToString:call.method]) {
        NSMutableArray* res = [NSMutableArray array];
        NSArray<LogItem*> *logs = _logModel.logs;
        for(LogItem *item in logs) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if ([item isKindOfClass:[JSLog class]]) {
                dict[@"type"] = @"log";
                dict[@"message"] = item.message;
            } else if([item isKindOfClass:[JSError class]]) {
                dict[@"type"] = @"error";
                dict[@"message"] = item.message;
                dict[@"stack"] = ((JSError*)item).stack;
                dict[@"name"] = ((JSError*)item).name;
            } else if([item isKindOfClass:[JSTrace class]]) {
                dict[@"type"] = @"trace";
                dict[@"message"] = item.message;
                dict[@"stack"] = ((JSTrace*)item).stack;
            } else if([item isKindOfClass:[SDKLog class]]) {
                dict[@"type"] = @"sdk";
                dict[@"message"] = item.message;
            }
            [res addObject:dict];
        }
        result([res copy]);
    } else if([kClearLogs isEqualToString:call.method]) {
        [_logModel clearLogs];
        result(@(YES));
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}


#pragma mark - SDKDelegate methods

- (void)onAdLoaded:(nullable NSError *)error {
    [_sdkCallbackChan invokeMethod:kAdLoaded arguments:nil];
}

- (void)onAdDidPlay {
    [_sdkCallbackChan invokeMethod:kAdDidPlay arguments:nil];
}

- (void)onAdDidClose {
    [_sdkCallbackChan invokeMethod:kAdDidClose arguments:nil];
}


#pragma mark - WebServerDelegate methods

-(void)onEndcardUploaded:(NSString *)zipName {
    [_webServerCallbackChan invokeMethod:kEndcardUploaded arguments:zipName];
}

#pragma mark - LogViewModelDelegate methods

-(void)onNewLogs {
    [_logModelCallbackChan invokeMethod:kNewLogs arguments:nil];
}



@end

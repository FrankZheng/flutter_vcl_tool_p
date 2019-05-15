//
//  SDKManagerProtocol.h
//  SDKManager
//
//  Created by frank.zheng on 2019/4/17.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDKDelegate <NSObject>
@optional
- (void)sdkDidInitialize;
- (void)onAdLoaded:(NSError *)error;
- (void)onAdDidPlay;
- (void)onAdDidClose;
- (void)onSDKLog:(NSString *)message;

//javascript debug stuff
- (void)onJSLog:(NSString *)jsLog;
- (void)onJSError:(NSString *)jsError;
- (void)onJSTrace:(NSString *)jsTrace;

@end


@protocol SDKManagerProtocol <NSObject>
@property(nonatomic, readonly) NSString *sdkVersion;
@property(nonatomic, copy) NSString *appId;
@property(nonatomic, copy) NSString *placementId;
@property(nonatomic, copy) NSURL *serverURL; //for mock the backend server
@property(nonatomic, assign) BOOL networkLoggingEnabled;

+ (instancetype)sharedManager;

- (void)addDelegate:(id<SDKDelegate>) delegate;

- (void)start;

- (void)loadAd;

- (void)playAd:(UIViewController*)viewController enableCORs:(BOOL)enableCORs;

- (void)clearCache;

- (void)forceCloseAd;

@end


NS_ASSUME_NONNULL_END

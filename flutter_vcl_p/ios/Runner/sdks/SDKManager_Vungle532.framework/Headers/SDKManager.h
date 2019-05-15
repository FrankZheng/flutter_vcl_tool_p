//
//  SDKManager.h
//  SDKManager
//
//  Created by frank.zheng on 2019/4/4.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for SDKManager.
FOUNDATION_EXPORT double SDKManagerVersionNumber;

//! Project version string for SDKManager.
FOUNDATION_EXPORT const unsigned char SDKManagerVersionString[];

#import "SDKManagerProtocol.h"

@protocol ForceCloseAdDelegate <NSObject>
- (void)onForceCloseAd;
@end

@interface SDKManager : NSObject<SDKManagerProtocol>
@property(nonatomic, weak) id<ForceCloseAdDelegate> forceCloseAdDelegate;
@property(nonatomic, readonly) BOOL isCORsEnabled;

//handle javascript debug stuff
- (void)onJSLog:(NSString *)log;
- (void)onJSError:(NSString *)error;
- (void)onJSTrace:(NSString *)trace;

@end


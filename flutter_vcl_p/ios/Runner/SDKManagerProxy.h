//
//  SDKManagerProxy.h
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/4.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDKManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDKManagerProxy : NSObject
@property(nonatomic, readonly) id<SDKManagerProtocol> sdkManager;
@property(nonatomic, strong) NSString *sdksFolderPath;

+ (instancetype)sharedProxy;

- (BOOL)load:(NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END

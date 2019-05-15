//
//  LogViewModel.h
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/4.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogItem.h"
#import "SDKManagerProxy.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LogViewModelDelegate
- (void)onNewLogs;
@end

@interface LogViewModel : NSObject<SDKDelegate>
@property(nonatomic, readonly) NSArray<LogItem*> *logs;
@property(nonatomic, weak) id<LogViewModelDelegate> delegate;
@property(nonatomic, copy) NSString *jsLogsFolderPath;

+ (instancetype)sharedInstance;

- (void)loadLogs;

- (void)clearLogs;

@end

NS_ASSUME_NONNULL_END

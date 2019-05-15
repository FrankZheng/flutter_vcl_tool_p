//
//  JSTrace.h
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/6.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSTrace : LogItem
@property(nonatomic, readonly) NSArray<NSString *> *stack;


- (instancetype)initWithTraceStr:(NSString *)traceStr;


@end

NS_ASSUME_NONNULL_END

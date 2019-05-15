//
//  JSError.h
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/3.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogItem.h"

@interface JSError : LogItem
@property(nonatomic, readonly, copy) NSString *name;
@property(nonatomic, readonly) NSArray<NSString *> *stack;

- (instancetype)initWithJsonStr:(NSString *)jsonStr;

+ (NSArray<NSString*> *)parseStack:(NSString *)stack;

@end

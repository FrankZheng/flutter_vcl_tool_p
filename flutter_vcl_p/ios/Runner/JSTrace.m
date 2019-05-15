//
//  JSTrace.m
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/6.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import "JSTrace.h"
#import "JSError.h"

#define kStack @"stack"

@implementation JSTrace


- (instancetype)initWithTraceStr:(NSString *)traceStr {
    self = [super initWithMessage:@"Trace"];
    if (self) {
        NSMutableArray *lines = [[JSError parseStack:traceStr] mutableCopy];
        if(lines.count > 0) {
            [lines removeObjectAtIndex:0];
            _stack = [lines copy];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _stack = [aDecoder decodeObjectForKey:kStack];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_stack forKey:kStack];
}


@end

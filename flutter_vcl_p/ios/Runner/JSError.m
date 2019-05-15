//
//  JSError.m
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/3.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import "JSError.h"

#define kName @"name"
#define kStack @"stack"

@interface JSError()
@end

@implementation JSError


- (instancetype)initWithDict:(NSDictionary *)dict {
    NSString *message = dict[@"msg"];
    self = [super initWithMessage:message];
    if (self) {
        _name = dict[@"errName"];
        _stack = [JSError parseStack:dict[@"stack"]];
    }
    return self;
}

- (instancetype)initWithJsonStr:(NSString *)jsonStr {
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if(dict == nil || err != nil) {
        NSLog(@"Failed to parse js error");
        return nil;
    }
    NSString *message = dict[@"msg"];
    self = [super initWithMessage:message];
    if(self) {
        _name = dict[@"errName"];
        _stack = [JSError parseStack:dict[@"stack"]];
    }
    return self;
}

+ (NSArray<NSString *> *)parseStack:(NSString *)stack {
    NSMutableArray *stackLines = [NSMutableArray array];
    NSArray *lines = [stack componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray* components = [line componentsSeparatedByString:@"@"];
        if (components.count > 1) {
            NSString *funcName = components[0];
            NSString *filePath = components[1];
            NSString *fileName = [filePath lastPathComponent];
            [stackLines addObject:[NSString stringWithFormat:@"%@ -- %@", funcName, fileName]];
            
        }
        else if(components.count == 1) {
            NSString *filePath = components[0];
            NSString *fileName = [filePath lastPathComponent];
            [stackLines addObject:[NSString stringWithFormat:@"(anonymous function) -- %@", fileName]];
        }
    }
    return [stackLines copy];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _name = [aDecoder decodeObjectForKey:kName];
        _stack = [aDecoder decodeObjectForKey:kStack];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_name forKey:kName];
    [coder encodeObject:_stack forKey:kStack];
}


@end

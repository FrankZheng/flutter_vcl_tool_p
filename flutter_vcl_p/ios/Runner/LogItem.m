//
//  LogItem.m
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/6.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import "LogItem.h"

#define kTimeStamp @"timestamp"
#define kMessage @"message"

@implementation LogItem

- (instancetype)init {
    self = [super init];
    if(self) {
        _timestamp = [NSDate date];
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message {
    self = [self init];
    if (self) {
        _message = [message copy];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _timestamp = [aDecoder decodeObjectForKey:kTimeStamp];
        _message = [aDecoder decodeObjectForKey:kMessage];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_timestamp forKey:kTimeStamp];
    [coder encodeObject:_message forKey:kMessage];
}



@end

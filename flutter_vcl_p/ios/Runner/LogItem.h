//
//  LogItem.h
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/6.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogItem : NSObject<NSCoding>
@property(nonatomic, readonly) NSDate *timestamp;
@property(nonatomic, readonly) NSString *message;

-(instancetype)initWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END

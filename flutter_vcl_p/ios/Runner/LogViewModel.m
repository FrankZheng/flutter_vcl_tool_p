//
//  LogViewModel.m
//  VungleCreativeTool
//
//  Created by frank.zheng on 2019/4/4.
//  Copyright © 2019 Vungle Inc. All rights reserved.
//

#import "LogViewModel.h"
#import "JSLog.h"
#import "JSError.h"
#import "JSTrace.h"
#import "SDKLog.h"
#import "SDKManagerProxy.h"

#define kJsLogs @"JsLogs"

@interface LogViewModel()
@property(nonatomic, strong) NSMutableArray<LogItem*> *logs;
@property(nonatomic, strong) NSString *jsLogsFilePath;

@end

@implementation LogViewModel

+ (instancetype)sharedInstance {
    static LogViewModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LogViewModel alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _logs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadLogs {
    _jsLogsFilePath = [_jsLogsFolderPath stringByAppendingPathComponent:@"js-logs.plist"];
    
    __weak typeof(self) weakSelf = self;
    //load logs in the background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfFile:weakSelf.jsLogsFilePath];
        if (data) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            weakSelf.logs = [unarchiver decodeObjectForKey:kJsLogs];
            [unarchiver finishDecoding];
            //dispatch new logs event
            [weakSelf.delegate onNewLogs];
        }
    });
}

- (void)clearLogs {
    _logs = [[NSMutableArray alloc] init];
    [self saveLogs];
    [_delegate onNewLogs];
}

- (void)saveLogs {
    //save logs
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_logs forKey:kJsLogs];
    [archiver finishEncoding];
    NSError *error = nil;
    if(![data writeToFile:_jsLogsFilePath options:NSDataWritingAtomic error:&error]) {
        NSLog(@"Failed to save js logs, %@", error);
    }
}

- (void)addLog:(LogItem *)log {
    [_logs addObject:log];
    [self saveLogs];
    //notify delegate
    [_delegate onNewLogs];
}

- (void)onSDKLog:(NSString *)message {
#if 0
    SDKLog *log = [[SDKLog alloc] initWithMessage:message];
    [self addLog:log];
#endif
}

- (void)onJSLog:(NSString *)jsLog {
    JSLog *log = [[JSLog alloc] initWithMessage:jsLog];
    [self addLog:log];
}

- (void)onJSTrace:(NSString *)jsTrace {
    JSTrace *log = [[JSTrace alloc] initWithTraceStr:jsTrace];
    [self addLog:log];
}


- (void)onJSError:(NSString *)jsError {
    NSLog(@"JS error: %@", jsError);
    JSError *error = [[JSError alloc] initWithJsonStr:jsError];
    [self addLog:error];
}




@end

//
//  SLLog.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLLog ()

@property (assign, nonatomic, readwrite) NSTimeInterval timestamp;
@property (copy, nonatomic, readwrite) NSString *logClass;
@property (copy, nonatomic, readwrite) NSString *string;
@property (copy, nonatomic, readwrite) NSString *function;
@property (assign, nonatomic, readwrite) SLLogLevel level;
@property (assign, nonatomic, readwrite) int threadId;
@property (copy, nonatomic, readwrite) NSString *queueLabel;
@property (copy, nonatomic, readwrite) NSArray *callstack;

@end


@implementation SLLog

- (instancetype)init {
    NSAssert(NO, @"This method cannot be used. Use [SLLog initWithString:className:moduleName:functionName:timestamp:] instead");
    return nil;
}

- (instancetype)initWithString:(NSString *)string className:(NSString *)className functionName:(NSString *)functionName timestamp:(NSTimeInterval)timestamp level:(SLLogLevel)level threadId:(int)threadId queueLabel:(NSString *)queueLabel callstack:(NSArray *)callstack {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _string = string;
    _logClass = className;
    _function = functionName;
    _timestamp = timestamp;
    _level = level;
    _threadId = threadId;
    _queueLabel = queueLabel;
    _callstack = callstack;
    
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SLLog *newLog = [[SLLog allocWithZone:zone] initWithString:_string className:_logClass functionName:_function timestamp:_timestamp level:_level threadId:_threadId queueLabel:_queueLabel callstack:_callstack];
    
    return newLog;
}

@end

NS_ASSUME_NONNULL_END

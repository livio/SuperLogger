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

@property (copy, nonatomic, readwrite) NSDate *timestamp;
@property (copy, nonatomic, readwrite) NSString *logClass;
@property (copy, nonatomic, readwrite) NSString *string;
@property (copy, nonatomic, readwrite) NSString *function;
@property (assign, nonatomic, readwrite) SLLogLevel level;

@end


@implementation SLLog

- (instancetype)init {
    NSAssert(NO, @"This method cannot be used. Use [SLLog initWithString:className:moduleName:functionName:timestamp:] instead");
    return nil;
}

- (instancetype)initWithString:(NSString *)string className:(NSString *)className functionName:(NSString *)functionName timestamp:(NSDate *)timestamp {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.string = string;
    self.logClass = className;
    self.function = functionName;
    self.timestamp = timestamp;
    
    return self;
}

@end

NS_ASSUME_NONNULL_END

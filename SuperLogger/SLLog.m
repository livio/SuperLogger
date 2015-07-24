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

@property (assign, nonatomic, readwrite) NSDate *timestamp;
@property (copy, nonatomic, readwrite) NSString *message;
@property (assign, nonatomic, readwrite) SLLogLevel level;
@property (copy, nonatomic, readwrite) NSString *queueLabel;
@property (copy, nonatomic, readwrite) NSArray *callstack;

@end


@implementation SLLog

- (instancetype)init {
    NSAssert(NO, @"This method cannot be used");
    return nil;
}

- (instancetype)initWithMessage:(NSString *)message timestamp:(NSDate *)timestamp level:(SLLogLevel)level queueLabel:(NSString *)queueLabel callstack:(NSArray *)callstack {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _message = message;
    _timestamp = timestamp;
    _level = level;
    _queueLabel = queueLabel;
    _callstack = callstack;
    
    return self;
}

- (NSArray *)componentsForCallstackLevel:(NSInteger)level {
    static NSCharacterSet *characterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@" +,-.?[]"];
    });
    
    NSString *symbol = self.callstack[level];
    NSArray *components = [symbol componentsSeparatedByCharactersInSet:characterSet];
    return [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
}

@end

NS_ASSUME_NONNULL_END

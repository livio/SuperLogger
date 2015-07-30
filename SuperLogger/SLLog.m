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
@property (assign, nonatomic, readwrite) NSInteger line;
@property (copy, nonatomic, readwrite) NSString *queueLabel;
@property (copy, nonatomic, readwrite) NSString *fileName;
@property (copy, nonatomic, readwrite) NSString *functionName;
@property (copy, nonatomic, readwrite) NSArray *callstack;


@end


@implementation SLLog

- (instancetype)init {
    NSAssert(NO, @"This method cannot be used");
    return nil;
}

- (instancetype)initWithMessage:(NSString *)message
                      timestamp:(NSDate *)timestamp
                          level:(SLLogLevel)level
                       fileName:(NSString *)fileName
                   functionName:(NSString *)functionName
                           line:(NSInteger)line
                     queueLabel:(NSString *)queueLabel
                      callstack:(NSArray *)callstack {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _message = message;
    _timestamp = timestamp;
    _level = level;
    _fileName = fileName;
    _functionName = functionName;
    _line = line;
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


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[SLLog allocWithZone:zone] initWithMessage:_message timestamp:_timestamp level:_level fileName:_fileName functionName:_functionName line:_line queueLabel:_queueLabel callstack:_callstack];
}

@end

NS_ASSUME_NONNULL_END

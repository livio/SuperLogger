//
//  SLLog.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"

@class SLClassModule;


NS_ASSUME_NONNULL_BEGIN

@interface SLLog : NSObject <NSCopying>

@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) NSDate *timestamp;
@property (assign, nonatomic, readonly) SLLogLevel level;
@property (assign, nonatomic, readonly) NSInteger line;
@property (copy, nonatomic, readonly) NSString *queueLabel;
@property (copy, nonatomic, readonly) NSString *fileName;
@property (copy, nonatomic, readonly) NSString *functionName;
@property (copy, nonatomic, readonly) NSArray *callstack;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMessage:(NSString *)message
                      timestamp:(NSDate *)timestamp
                          level:(SLLogLevel)level
                       fileName:(NSString *)fileName
                   functionName:(NSString *)functionName
                           line:(NSInteger)line
                     queueLabel:(NSString *)queueLabel
                      callstack:(NSArray *)callstack NS_DESIGNATED_INITIALIZER;

- (NSArray *)componentsForCallstackLevel:(NSInteger)level;

@end

NS_ASSUME_NONNULL_END

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

@property (assign, nonatomic, readonly) NSTimeInterval timestamp;
@property (copy, nonatomic, readonly) NSString *logClass;
@property (copy, nonatomic, readonly) NSString *string;
@property (copy, nonatomic, readonly) NSString *function;
@property (assign, nonatomic, readonly) SLLogLevel level;
@property (assign, nonatomic, readonly) int threadId;
@property (copy, nonatomic, readonly) NSString *queueLabel;
@property (copy, nonatomic, readonly) NSArray *callstack;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithString:(NSString *)string className:(NSString *)className functionName:(NSString *)functionName timestamp:(NSTimeInterval)timestamp level:(SLLogLevel)level threadId:(int)threadId queueLabel:(NSString *)queueLabel callstack:(NSArray *)callstack NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

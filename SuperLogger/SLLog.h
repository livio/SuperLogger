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
@property (assign, nonatomic, readonly) NSDate *timestamp;
@property (assign, nonatomic, readonly) SLLogLevel level;
@property (copy, nonatomic, readonly) NSString *queueLabel;
@property (copy, nonatomic, readonly) NSArray *callstack;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMessage:(NSString *)message timestamp:(NSDate *)timestamp level:(SLLogLevel)level queueLabel:(NSString *)queueLabel callstack:(NSArray *)callstack NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

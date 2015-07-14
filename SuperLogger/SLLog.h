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

@interface SLLog : NSObject

@property (copy, nonatomic, readonly) NSDate *timestamp;
@property (copy, nonatomic, readonly) NSString *logClass;
@property (copy, nonatomic, readonly) NSString *string;
@property (copy, nonatomic, readonly) NSString *function;
@property (assign, nonatomic, readonly) SLLogLevel level;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithString:(NSString *)string className:(NSString *)className functionName:(NSString *)functionName timestamp:(NSDate *)timestamp NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

//
//  SLLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"

@class SLLog;


NS_ASSUME_NONNULL_BEGIN

@protocol SLLogger <NSObject>
@required

/**
 *  By default this will be the SLLoggerController default block. The format for this logger can be customized by using this block.
 */
@property (copy, nonatomic, nullable) SLLogFormatBlock formatBlock;

/**
 *  If this is NO, when not in DEBUG, the logger will not receive any messages to set up, tear down, or log.
 */
@property (assign, nonatomic) BOOL logInRelease;

- (void)setupLogger;
- (void)logString:(NSString *)string;
- (void)teardownLogger;

@end

NS_ASSUME_NONNULL_END

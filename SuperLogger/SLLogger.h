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
 *  If this is NO, when not in DEBUG, the logger will not receive any messages to set up, tear down, or log. All loggers should default to YES.
 */
@property (assign, nonatomic) BOOL logInRelease;

- (void)setupLogger;
- (void)logWithLog:(SLLog *)log formattedLog:(NSString *)stringLog;
- (void)teardownLogger;

@end

NS_ASSUME_NONNULL_END

//
//  SLWebLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 9/14/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLLogger.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLWebLogger : NSObject <SLLogger>

/**
 *  Defaults to NO.
 */
@property (assign, nonatomic) BOOL logInRelease;

/**
 *  Returns the URL of the server
 *
 *  @warning Will return nil if the server is not started.
 */
@property (copy, nonatomic, readonly, nullable) NSString *URL;

- (instancetype)init;
- (instancetype)initWithPort:(UInt16)port NS_DESIGNATED_INITIALIZER;

/**
 *  Start with default port (12346)
 *
 *  @return An instance of SLWebLogger
 */
+ (instancetype)logger;

/**
 *  Set up with a specific port, or 0 for random.
 *
 *  @param port The specific port to be used, or 0 for random.
 *
 *  @return An instance of SLWebLogger
 */
+ (instancetype)loggerWithPort:(UInt16)port;

- (BOOL)setupLogger;
- (void)logWithLog:(SLLog *)log formattedLog:(NSString *)stringLog;
- (void)teardownLogger;

@end

NS_ASSUME_NONNULL_END

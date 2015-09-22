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

typedef NS_ENUM(NSUInteger, IPType) {
    IPTypeV4,
    IPTypeV6
};

@interface SLWebLogger : NSObject <SLLogger>

/**
 *  Defaults to NO.
 */
@property (assign, nonatomic) BOOL logInRelease;

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

/**
 *  Return the URL that the server is running on
 *
 *  @param ipAddressType Whether the URL should try to return an ipv4 url or an ipv6 url
 *
 *  @return The URL of the server or nil if the server is not running
 */
- (nullable NSString *)serverURLForType:(IPType)ipAddressType;

@end

NS_ASSUME_NONNULL_END

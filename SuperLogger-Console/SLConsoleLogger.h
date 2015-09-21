//
//  SLConsoleLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLLogger.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLConsoleLogger : NSObject <SLLogger>

/**
 *  Defaults to NO
 */
@property (assign, nonatomic) BOOL logInRelease;

+ (instancetype)logger;

@end

NS_ASSUME_NONNULL_END

//
//  SLASLLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 8/26/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLLogger.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLASLLogger : NSObject <SLLogger>

/**
 *  Defaults to NO
 */
@property (assign, nonatomic) BOOL logInRelease;

+ (instancetype)logger;

@end

NS_ASSUME_NONNULL_END

//
//  SLNSLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 5/20/16.
//  Copyright © 2016 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLLogger.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLNSLogger : NSObject <SLLogger>

/**
 *  Defaults to NO
 */
@property (assign, nonatomic) BOOL logInRelease;

+ (instancetype)logger;

@end

NS_ASSUME_NONNULL_END

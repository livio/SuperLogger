//
//  SLFileLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/13/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLLogger.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLFileLogger : NSObject <SLLogger>

@property (copy, nonatomic, nullable) SLLogFormatBlock formatBlock;

/**
 *  Defaults to 5
 */
@property (assign, nonatomic) NSUInteger maxNumLogFiles;

/**
 *  Defaults to YES
 */
@property (assign, nonatomic) BOOL logInRelease;

+ (NSString *)logDirectory;

@end

NS_ASSUME_NONNULL_END

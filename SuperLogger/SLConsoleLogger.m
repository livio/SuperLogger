//
//  SLConsoleLogger.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLConsoleLogger.h"

#import "SLLog.h"
#import "SLLoggerController.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SLConsoleLogger

- (void)logString:(NSString *)string {
    NSLog(@"%@", string);
}

@end

NS_ASSUME_NONNULL_END

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

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _logInRelease = YES;
    
    return self;
}

- (instancetype)logger {
    return [[self alloc] init];
}


#pragma mark - SLLogger

- (void)setupLogger {
    
}

- (void)log:(SLLog *)log {
    
}

- (void)teardownLogger {
    
}

@end

NS_ASSUME_NONNULL_END

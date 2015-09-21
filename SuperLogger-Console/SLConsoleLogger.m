//
//  SLConsoleLogger.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLConsoleLogger.h"

#import "SLLog.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SLConsoleLogger

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _logInRelease = NO;
    
    return self;
}

+ (instancetype)logger {
    return [[self alloc] init];
}


#pragma mark - SLLogger

- (BOOL)setupLogger {
    return YES;
}

- (void)logWithLog:(SLLog *)log formattedLog:(NSString *)stringLog {
    NSData *formattedLogData = [stringLog dataUsingEncoding:NSUTF8StringEncoding];
    
    NSInteger writtenBytes = write(STDERR_FILENO, formattedLogData.bytes, formattedLogData.length);
    if (writtenBytes < 0) {
        // TODO: We errored pretty hard, we should tell somebody
        NSAssert(writtenBytes < 0, @"Error writing to stderr");
    }
}

- (void)teardownLogger {
    
}

@end

NS_ASSUME_NONNULL_END

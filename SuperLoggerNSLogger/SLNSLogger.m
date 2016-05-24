//
//  SLNSLogger.m
//  SuperLogger
//
//  Created by Joel Fischer on 5/20/16.
//  Copyright © 2016 livio. All rights reserved.
//

#import "SLNSLogger.h"

#import "SLLog.h"

#import <dlfcn.h>


NS_ASSUME_NONNULL_BEGIN

@implementation SLNSLogger

#pragma mark - NSLogger

// https://github.com/fpillet/NSLogger/wiki/Using-NSLogger-in-frameworks-and-libraries
/* This code provides a logging function you can use from within frameworks.
 * When using the framework with a client application, the code will either
 * use NSLogger if it is linked in the application, or go with a regular NSLog() call
 *
 * Helpful to provide debug versions of frameworks that can take advantage of NSLogger.
 *
 * This requires NSLogger 1.5.1 or later, which tags its log functions with the proper attribute to
 * prevent them from being stripped. Client application MUST define NSLOGGER_ALLOW_NOSTRIP or use
 * the "NSLogger/NoStrip" CocoaPod
 */

typedef void (*LogMessageF_func)(const char *file, int line, const char *function,
NSString *tag, int level, NSString * const format,
va_list args);

void FrameworkLog(const char *file, int line, const char *function, NSString *tag, int level, ...)
{
    static LogMessageF_func logFunc;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        logFunc = dlsym(RTLD_DEFAULT, "LogMessageF_va");
    });
    
    va_list args;
    va_start(args, level);
    NSString * format = va_arg(args, NSString *);
    if (logFunc) {
        // we know that this symbol exists, so we can safely call it
        logFunc(file, line, function, tag, level, format, args);
    } else {
        NSLog(@"[%@] %@", tag, [[NSString alloc] initWithFormat:format arguments:args]);
    }
    va_end(args);
}

#pragma mark - SLNSLogger

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
    FrameworkLog(log.fileName.UTF8String, (int)log.line, log.functionName.UTF8String, @"SL", log.level, log.message);
}

- (void)teardownLogger {
    
}

@end


NS_ASSUME_NONNULL_END

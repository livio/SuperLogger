//
//  SLLog.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLoggerController.h"

#import "SLLog.h"
#import "SLLogSearch.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLLoggerController ()

@property (copy, nonatomic, readwrite) NSMutableSet<id<SLLogger>> *mutableLoggers;
@property (copy, nonatomic, readwrite) NSMutableSet<SLLogFilterBlock> *mutableLogFilters;
@property (copy, nonatomic, readwrite) NSMutableSet<SLClassModule *> *mutableLogModules;

@end


@implementation SLLoggerController

#pragma mark - Lifecycle

+ (SLLoggerController *)sharedController {
    static SLLoggerController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    
    return sharedController;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _mutableLoggers = [NSMutableSet set];
    _mutableLogFilters = [NSMutableSet set];
    _mutableLogModules = [NSMutableSet set];
    
    return self;
}

+ (void)addLoggers:(NSArray<id<SLLogger>> *)loggers {
    dispatch_async([self.class globalLogQueue], ^{ @autoreleasepool {
        for (id<SLLogger> logger in loggers) {
#ifndef DEBUG
            // If the app is running in release mode, and the logger should not run in release mode, then just ignore this logger.
            if (!logger.logInRelease) {
                continue;
            }
#endif
            // If the logger should be set up, then set it up.
            [[self.class sharedController].mutableLoggers addObject:logger];
            [logger setupLogger];
        }
    }});
}

+ (void)addModules:(NSArray<SLClassModule *> *)modules {
    dispatch_async([self.class globalLogQueue], ^{ @autoreleasepool {
        [[self.class sharedController].mutableLogModules addObjectsFromArray:modules];
    }});
}

+ (void)addFilters:(NSArray<SLLogFilterBlock> *)filters {
    dispatch_async([self.class globalLogQueue], ^{ @autoreleasepool {
        [[self.class sharedController].mutableLogFilters addObjectsFromArray:filters];
    }});
}


#pragma mark - Logging

+ (void)logString:(SLLogLevel)level message:(NSString *)message, ... {
    if (!message) {
        return;
    }
    
    NSArray *callstack = [NSThread callStackSymbols];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *currentQueueLabel = [NSString stringWithCString:dispatch_queue_get_label(dispatch_get_current_queue()) encoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    
    va_list args;
    va_start(args, message);
    NSString *format = [[NSString alloc] initWithFormat:message arguments:args];
    SLLog *log = [[SLLog alloc] initWithMessage:format timestamp:[NSDate date] level:level queueLabel:currentQueueLabel callstack:callstack];
    
    [[self sharedController] sl_logMessage:log];
}

- (void)sl_logMessage:(SLLog *)log {
    if (log.level == SLLogLevelError) {
        if (self.errorAsync) {
            [self sl_asyncLog:log];
        } else {
            [self sl_syncLog:log];
        }
    } else {
        if (self.async) {
            [self sl_asyncLog:log];
        } else {
            [self sl_syncLog:log];
        }
    }
}

- (void)sl_asyncLog:(SLLog *)log {
    dispatch_async([SLLoggerController globalLogQueue], ^{ @autoreleasepool {
        [self sl_log:log];
    }});
}

- (void)sl_syncLog:(SLLog *)log {
    dispatch_sync([SLLoggerController globalLogQueue], ^{ @autoreleasepool {
        [self sl_log:log];
    }});
}

- (void)sl_log:(SLLog *)log {
    for (SLLogFilterBlock filter in self.logFilters) {
        if (filter(log) == NO) {
            return;
        }
    }
    
    for (id<SLLogger> logger in self.loggers) {
        SLLogFormatBlock formatBlock = logger.formatBlock ?: [self defaultFormatBlock];
        [logger logString:formatBlock(log)];
    }
}


#pragma mark - Searching

+ (void)searchStoredLogsWithFilters:(NSArray<SLLogFilterBlock> *)searchFilters completion:(SLSearchCompletionBlock)completionBlock {
    dispatch_async([SLLoggerController globalLogQueue], ^{ @autoreleasepool {
        // Go through our loggers and find those that support searching
        // TODO: Only search a passed in logger?
        for (id<SLLogger> logger in [self.class sharedController].loggers) {
            if ([logger conformsToProtocol:@protocol(SLLogSearch)] && [logger respondsToSelector:@selector(searchStoredLogsWithFilter:error:)]) {
                NSError *error = nil;
                
                // Search the logs
                NSArray *results = [(id<SLLogSearch>)logger searchStoredLogsWithFilter:searchFilters error:&error];
                
                // Report back to the main thread with the result or error
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(results, error);
                });
            }
        }
    }});
}


#pragma mark - Dispatch Queues

+ (dispatch_queue_t)globalLogQueue {
    static dispatch_queue_t queue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.superlogger.loggercontroller.log", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

//+ (dispatch_queue_t)searchQueue {
//    static dispatch_queue_t queue = NULL;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        queue = dispatch_queue_create("com.superlogger.loggercontroller.search", DISPATCH_QUEUE_CONCURRENT);
//    });
//    
//    return queue;
//}

@end

NS_ASSUME_NONNULL_END

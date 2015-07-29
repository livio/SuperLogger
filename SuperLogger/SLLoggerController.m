//
//  SLLog.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLoggerController.h"

#import "SLFileModule.h"
#import "SLLog.h"
#import "SLLogSearch.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLLoggerController ()

@property (copy, nonatomic, readwrite) NSMutableSet<id<SLLogger>> *mutableLoggers;
@property (copy, nonatomic, readwrite) NSMutableSet<SLLogFilterBlock> *mutableLogFilters;
@property (copy, nonatomic, readwrite) NSMutableSet<SLFileModule *> *mutableLogModules;

@end


@implementation SLLoggerController

@synthesize defaultFormatBlock = _defaultFormatBlock;

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
    
    _async = YES;
    _errorAsync = NO;
    _globalLogLevel = SLLogLevelDebug;
    _defaultFormatBlock = nil;
    
    return self;
}


#pragma mark - Set adding / removing

#pragma Shared Instance
+ (void)addLoggers:(NSArray<id<SLLogger>> *)loggers {
    [[self.class sharedController] addLoggers:loggers];
}

+ (void)addModules:(NSArray<SLFileModule *> *)modules {
    [[self.class sharedController] addModules:modules];
}

+ (void)addFilters:(NSArray<SLLogFilterBlock> *)filters {
    [[self.class sharedController] addFilters:filters];
}

+ (void)removeLoggers:(NSArray<id<SLLogger>> *)loggers {
    [[self.class sharedController] removeLoggers:loggers];
}

+ (void)removeModules:(NSArray<SLFileModule *> *)modules {
    [[self.class sharedController] removeModules:modules];
}

+ (void)removeFilters:(NSArray<SLLogFilterBlock> *)filters {
    [[self.class sharedController] removeFilters:filters];
}

- (void)addLoggers:(NSArray<id<SLLogger>> *)loggers {
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

#pragma Instance Methods
- (void)addModules:(NSArray<SLFileModule *> *)modules {
    dispatch_async([self.class globalLogQueue], ^{ @autoreleasepool {
        [[self.class sharedController].mutableLogModules addObjectsFromArray:modules];
    }});
}

- (void)addFilters:(NSArray<SLLogFilterBlock> *)filters {
    dispatch_async([self.class globalLogQueue], ^{ @autoreleasepool {
        [[self.class sharedController].mutableLogFilters addObjectsFromArray:filters];
    }});
}

- (void)removeLoggers:(nonnull NSArray<id<SLLogger>> *)loggers {
    dispatch_async([self.class globalLogQueue], ^{
        for (id<SLLogger> logger in loggers) {
            [logger teardownLogger];
            [[self.class sharedController].mutableLoggers removeObject:logger];
        }
    });
}

- (void)removeModules:(NSArray<SLFileModule *> *)modules {
    dispatch_async([self.class globalLogQueue], ^{
        for (SLFileModule *module in modules) {
            [[self.class sharedController].mutableLogModules removeObject:module];
        }
    });
}

- (void)removeFilters:(NSArray<SLLogFilterBlock> *)filters {
    dispatch_async([self.class globalLogQueue], ^{
        for (SLLogFilterBlock filter in filters) {
            [[self.class sharedController].mutableLogFilters removeObject:filter];
        }
    });
}


#pragma mark - Log Level

+ (SLLogLevel)logLevelForFile:(NSString *)file {
    return [[self.class sharedController] logLevelForFile:file];
}

- (SLLogLevel)logLevelForFile:(NSString *)file {
    for (SLFileModule *module in [self.class sharedController].logModules) {
        if ([module containsFile:file]) {
            return module.logLevel;
        }
    }
    
    return [self.class sharedController].globalLogLevel;
}


#pragma mark - Getters / Setters

- (SLLogFormatBlock)defaultFormatBlock {
    if (_defaultFormatBlock != nil) {
        return _defaultFormatBlock;
    } else {
        return [^NSString * (SLLog *log) {
            NSString *callerClass = log.fileName;
            NSString *callerFunction = log.functionName;
            return [NSString stringWithFormat:@"(%@:%@)[%@ %@] %@", log.queueLabel, log.timestamp, callerClass, callerFunction, log.message];
        } copy];
    }
}

- (void)setDefaultFormatBlock:(SLLogFormatBlock)defaultFormatBlock {
    dispatch_async([self.class globalLogQueue], ^{
        _defaultFormatBlock = defaultFormatBlock;
    });
}


#pragma mark - Logging

+ (void)logStringWithLevel:(SLLogLevel)level fileName:(const char *)fileName functionName:(const char *)functionName line:(NSInteger)line message:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    
    [[self.class sharedController] logStringWithLevel:level fileName:fileName functionName:functionName line:line message:message, args];
    
    va_end(args);
}

- (void)logStringWithLevel:(SLLogLevel)level fileName:(const char *)fileName functionName:(const char *)functionName line:(NSInteger)line message:(NSString *)message, ... {
    NSDate *timestamp = [NSDate date];
    NSArray *callstack = [NSThread callStackSymbols];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *currentQueueLabel = [NSString stringWithCString:dispatch_queue_get_label(dispatch_get_current_queue()) encoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    
    va_list args;
    va_start(args, message);
    NSString *format = [[NSString alloc] initWithFormat:message arguments:args];
    
    SLLog *log = [[SLLog alloc] initWithMessage:format
                                      timestamp:timestamp
                                          level:level
                                       fileName:[NSString stringWithFormat:@"%s", fileName]
                                   functionName:[NSString stringWithFormat:@"%s", functionName]
                                           line:line
                                     queueLabel:currentQueueLabel
                                      callstack:callstack];
    [self queueLog:log];
    
    va_end(args);
}

+ (void)queueLog:(SLLog *)log {
    [[self.class sharedController] queueLog:log];
}

- (void)queueLog:(SLLog *)log {
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

@end

NS_ASSUME_NONNULL_END

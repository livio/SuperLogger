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

@property (assign, nonatomic) SLLogFormatBlock defaultFormatBlock;

@end


@implementation SLLoggerController

@synthesize formatBlock = _formatBlock, timestampFormatter = _timestampFormatter;

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
    _formatBlock = nil;
    _defaultFormatBlock = [self.class sl_defaultFormatBlock];
    _timestampFormatter = nil;
    
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

#pragma Instance Methods
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
            [self.mutableLoggers addObject:logger];
            [logger setupLogger];
        }
    }});
}

- (void)addModules:(NSArray<SLFileModule *> *)modules {
    dispatch_async([self.class globalLogQueue], ^{ @autoreleasepool {
        [self.mutableLogModules addObjectsFromArray:modules];
    }});
}

- (void)addFilters:(NSArray<SLLogFilterBlock> *)filters {
    dispatch_async([self.class globalLogQueue], ^{ @autoreleasepool {
        [self.mutableLogFilters addObjectsFromArray:filters];
    }});
}

- (void)removeLoggers:(nonnull NSArray<id<SLLogger>> *)loggers {
    dispatch_async([self.class globalLogQueue], ^{
        for (id<SLLogger> logger in loggers) {
            [logger teardownLogger];
            [self.mutableLoggers removeObject:logger];
        }
    });
}

- (void)removeModules:(NSArray<SLFileModule *> *)modules {
    dispatch_async([self.class globalLogQueue], ^{
        for (SLFileModule *module in modules) {
            [self.mutableLogModules removeObject:module];
        }
    });
}

- (void)removeFilters:(NSArray<SLLogFilterBlock> *)filters {
    dispatch_async([self.class globalLogQueue], ^{
        for (SLLogFilterBlock filter in filters) {
            [self.mutableLogFilters removeObject:filter];
        }
    });
}


#pragma mark - Log Level

- (SLLogLevel)logLevelForFile:(NSString *)file {
    for (SLFileModule *module in self.logModules) {
        if ([module containsFile:file]) {
            if (module.logLevel == SLLogLevelDefault) {
                break;
            }
            
            return module.logLevel;
        }
    }
    
    return self.globalLogLevel;
}


#pragma mark - Getters / Setters

- (SLLogFormatBlock)formatBlock {
    if (_formatBlock != nil) {
        return _formatBlock;
    } else {
        return _defaultFormatBlock;
    }
}

- (void)setFormatBlock:(SLLogFormatBlock)formatBlock {
    dispatch_async([self.class globalLogQueue], ^{
        _formatBlock = formatBlock;
    });
}

- (NSDateFormatter *)timestampFormatter {
    if (_timestampFormatter != nil) {
        return _timestampFormatter;
    } else {
        return [self.class sl_dateFormatter];
    }
}

- (void)setTimestampFormatter:(NSDateFormatter *)timestampFormatter {
    dispatch_async([self.class globalLogQueue], ^{
        _timestampFormatter = timestampFormatter;
    });
}

+ (SLLogFormatBlock)sl_defaultFormatBlock {
    return [^NSString *(SLLog *log, NSDateFormatter *dateFormatter) {
        NSString *dateString = [dateFormatter stringFromDate:log.timestamp];
        // TODO: a comment with example output
        return [NSString stringWithFormat:@"[%@:%ld] (%@:%@) (%@) %@", log.fileName, (long)log.line, log.queueLabel, dateString, log.functionName, log.message];
    } copy];
}

#pragma mark Readonly, Immutable Sets

- (NSSet<SLFileModule *> *)logModules {
    return [NSSet setWithSet:self.mutableLogModules];
}

- (NSSet<id<SLLogger>> *)loggers {
    return [NSSet setWithSet:self.mutableLoggers];
}

- (NSSet<SLLogFilterBlock> *)logFilters {
    return [NSSet setWithSet:self.mutableLogFilters];
}


#pragma mark - Logging

+ (void)logWithLevel:(SLLogLevel)level fileName:(NSString *)fileName functionName:(NSString *)functionName line:(NSInteger)line message:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    
    [[self.class sharedController] logWithLevel:level fileName:fileName functionName:functionName line:line message:message, args];
    
    va_end(args);
}

- (void)logWithLevel:(SLLogLevel)level fileName:(NSString *)fileName functionName:(NSString *)functionName line:(NSInteger)line message:(NSString *)message, ... {
    NSDate *timestamp = [NSDate date];
    NSArray *callstack = [NSThread callStackSymbols];
    
    va_list args;
    va_start(args, message);
    NSString *format = [[NSString alloc] initWithFormat:message arguments:args];
    
    SLLog *log = [[SLLog alloc] initWithMessage:format
                                      timestamp:timestamp
                                          level:level
                                       fileName:fileName
                                   functionName:functionName
                                           line:line
                                     queueLabel:SLOG_QUEUE
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
    if ([self logLevelForFile:log.fileName] < log.level) {
        return;
    }
    
    for (SLLogFilterBlock filter in self.logFilters) {
        if (filter(log) == NO) {
            return;
        }
    }
    
    NSString *formattedLog = self.formatBlock(log, self.timestampFormatter);
    for (id<SLLogger> logger in self.loggers) { @autoreleasepool {
        [logger logWithLog:log formattedLog:formattedLog];
    }}
}


#pragma mark - Searching

+ (void)searchStoredLogsWithFilters:(NSArray<SLLogFilterBlock> *)searchFilters completion:(SLSearchCompletionBlock)completionBlock {
    [[self.class sharedController] searchStoredLogsWithFilters:searchFilters completion:completionBlock];
}

- (void)searchStoredLogsWithFilters:(NSArray<SLLogFilterBlock> *)searchFilters completion:(SLSearchCompletionBlock)completionBlock {
    dispatch_async([SLLoggerController globalLogQueue], ^{ @autoreleasepool {
        // Go through our loggers and find those that support searching
        // TODO: Only search a passed in logger? Not happy w/ this implementation
        for (id<SLLogger> logger in self.loggers) {
            if ([logger conformsToProtocol:@protocol(SLLogSearch)] && [logger respondsToSelector:@selector(searchStoredLogsWithFilter:error:)]) {
                NSError *error = nil;
                
                // Search the logs
                NSArray *results = [(id<SLLogSearch>)logger searchStoredLogsWithFilter:searchFilters error:&error];
                
                // Report back to the main thread with the result or error
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(results, error);
                });
                
                break;
            }
        }
    }});
}


#pragma mark - Singletons

+ (dispatch_queue_t)globalLogQueue {
    static dispatch_queue_t queue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.superlogger.loggercontroller.log", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

+ (NSDateFormatter *)sl_dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yy-mm-dd | HH:mm:ss:SSSS";
    });
    
    return formatter;
}

@end

NS_ASSUME_NONNULL_END

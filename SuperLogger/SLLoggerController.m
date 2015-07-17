//
//  SLLog.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLoggerController.h"

#import "SLLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLLoggerController ()

@property (copy, nonatomic, readwrite) NSMutableSet<id<SLLogger>> *loggers;
@property (copy, nonatomic, readwrite) NSMutableSet<SLLogFilterBlock> *logFilters;
@property (copy, nonatomic, readwrite) NSMutableSet<SLClassModule *> *mutableLogModules;

@end


@implementation SLLoggerController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [self initWithLoggers:@[]];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithLoggers:(NSArray<id<SLLogger>> *)loggers {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _loggers = [NSMutableSet<id<SLLogger>> setWithArray:loggers];
    _logFilters = [NSMutableSet set];
    _mutableLogModules = [NSMutableSet set];
    _async = YES;
    _errorAsync = NO;
    
    return self;
}

- (instancetype)initWithLoggers:(NSArray<id<SLLogger>> *)loggers modules:(NSArray<SLClassModule *> *)modules {
    self = [self initWithLoggers:loggers];
    if (!self) {
        return nil;
    }
    
    [_mutableLogModules addObjectsFromArray:modules];
    
    return self;
}

- (void)addModules:(NSArray<SLClassModule *> *)modules {
    [self.mutableLogModules addObjectsFromArray:modules];
}

- (void)addLogFilters:(NSSet *)objects {
    
}


#pragma mark - Logging

- (void)log:(SLLog *)log {
    if (self.async == YES) {
        [self sl_asyncLog:log];
    } else {
        [self sl_log:log];
    }
}

- (void)sl_asyncLog:(SLLog *)log {
    dispatch_async([SLLoggerController globalLogQueue], ^{
        [self sl_log:log];
    });
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
    
    // TODO: Store logs in some way for future searches
}


#pragma mark - Searching

- (void)searchStoredLogsWithFilters:(NSArray<SLLogFilterBlock> *)searchFilterBlock completion:(SLSearchCompletionBlock)completionBlock {
    dispatch_async(self.searchDispatchQueue, ^{
        // TODO
        // http://nshipster.com/search-kit/
        // https://github.com/indragiek/SNRSearchIndex
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(@[], nil);
        });
    });
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

+ (dispatch_queue_t)searchQueue {
    static dispatch_queue_t queue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.superlogger.loggercontroller.search", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return queue;
}

@end

NS_ASSUME_NONNULL_END

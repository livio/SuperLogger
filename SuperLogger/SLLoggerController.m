//
//  SLLog.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLoggerController.h"

#import "SLConsoleLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLLoggerController ()

@property (strong, nonatomic, readwrite) dispatch_queue_t logDispatchQueue;
@property (strong, nonatomic, readwrite) dispatch_queue_t searchDispatchQueue;
@property (copy, nonatomic, readwrite) NSMutableSet<id<SLLogger>> *loggers;
@property (copy, nonatomic, readwrite) NSMutableSet<SLLogFilterBlock> *logFilters;

@end


@implementation SLLoggerController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [self initWithLoggers:@[[[SLConsoleLogger alloc] init]]];
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
    
    self.logDispatchQueue = dispatch_queue_create("com.superlogger.loggercontroller.log", DISPATCH_QUEUE_SERIAL);
    self.searchDispatchQueue = dispatch_queue_create("com.superlogger.loggercontroller.search", DISPATCH_QUEUE_CONCURRENT);
    
    self.loggers = [NSMutableSet<id<SLLogger>> setWithArray:loggers];
    self.logFilters = [NSMutableSet set];
    self.async = YES;
    self.errorAsync = NO;
    self.maxStoredLogs = 1000;
    
    return self;
}

- (void)addLogFilters:(NSSet *)objects {
    
}


#pragma mark - Searching

- (void)searchStoredLogsWithFilter:(SLLogFilterBlock)searchFilterBlock completion:(void(^)(NSArray<NSString *> *results))completionBlock {
    dispatch_async(self.searchDispatchQueue, ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(@[]);
        });
    });
}

@end

NS_ASSUME_NONNULL_END

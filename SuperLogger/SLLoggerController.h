//
//  SLLog.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLLogger.h"
#import "SLGlobals.h"

@class SLClassModule;
@class SLLog;


NS_ASSUME_NONNULL_BEGIN

@interface SLLoggerController : NSObject

/**
 *  The serial dispatch queue that will be used to send logs through filters and to the logger.
 */
@property (strong, nonatomic, readonly) dispatch_queue_t logDispatchQueue;

/**
 *  The concurrent dispatch queue that will be used to search over past logs in history.
 */
@property (strong, nonatomic, readonly) dispatch_queue_t searchDispatchQueue;

/**
 *  All known log modules. Add modules early on. When a log is sent from a class that is contained in a module, the module will automatically be logged.
 */
@property (copy, nonatomic, readonly) NSSet<SLClassModule *> *logModules;

/**
 *  All currently active loggers
 */
@property (copy, nonatomic, readonly) NSSet<id<SLLogger>> *loggers;

/**
 *  All currently active log filters.
 */
@property (copy, nonatomic, readonly) NSSet<SLLogFilterBlock> *logFilters;

/**
 *  The default format block that will be used if a logger's format block is nil
 */
@property (copy, nonatomic, readonly) SLLogFormatBlock defaultFormatBlock;

/**
 *  Whether or not non-error logs will be dispatched asynchronously.
 */
@property (assign, nonatomic) BOOL async;

/**
 *  Whether or not error logs will be dispatched to loggers asynchronously.
 *  Default is NO
 */
@property (assign, nonatomic) BOOL errorAsync;

+ (SLLoggerController *)sharedController;

/**
 *  Add loggers, modules, or filters to the shared instance
 */
+ (void)addLoggers:(NSArray<id<SLLogger>> *)loggers;
+ (void)addModules:(NSArray<SLClassModule *> *)modules;
+ (void)addFilters:(NSArray<SLLogFilterBlock> *)filters;

/**
 *  Use a filter to return a list of stored logs that pass the filter. This will run on the search dispatch queue, which is a concurrent queue. It will return on the main queue.
 *
 *  @param searchFilterBlock The search filter that will be applied over the past logs.
 *
 *  @return An array of logs that passed the filter. Position 0 (zero) of the array contains the oldest log from the search.
 */
+ (void)searchStoredLogsWithFilters:(NSArray<SLLogFilterBlock> *)searchFilters completion:(SLSearchCompletionBlock)completionBlock;

+ (void)logString:(NSString *)message, ... NS_FORMAT_FUNCTION(1, 2);


+ (dispatch_queue_t)globalLogQueue;

@end

NS_ASSUME_NONNULL_END

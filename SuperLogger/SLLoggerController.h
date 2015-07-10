//
//  SLLog.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLLogger.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SLLogFilterLevel) {
    SLLogFilterLevelVerbose = 0,
    SLLogFilterLevelDebug,
    SLLogFilterLevelInfo,
    SLLogFilterLevelWarn,
    SLLogFilterLevelError
};

/**
 *  A block run over logs to filter results into 'good' and 'bad'. 'Good' log results pass the filter and continue. 'Bad' log results are stopped at the filter.
 *
 *  @param logString The string that was passed to the log method
 *  @param level     The log level that determines the priority of the log being passed
 *
 *  @return 'YES' if the log passes the filter.
 */
typedef BOOL (^SLLogFilterBlock)(NSString *logString, SLLogFilterLevel level);


@interface SLLoggerController : NSObject

/**
 *  The serial dispatch queue that will be used to send logs through filters and to the logger.
 */
@property (strong, nonatomic, readonly) dispatch_queue_t logDispatchQueue;

/**
 *  The concurrent dispatch queue that will be used to search over past logs in history.
 */
@property (strong, nonatomic, readonly) dispatch_queue_t searchDispatchQueue;

@property (copy, nonatomic, readonly) NSMutableSet<NSNumber *> *logModules;

/**
 *  All currently active loggers
 */
@property (copy, nonatomic, readonly) NSMutableSet<id<SLLogger>> *loggers;

/**
 *  All currently active log filters.
 */
@property (copy, nonatomic, readonly) NSMutableSet<SLLogFilterBlock> *logFilters;

/**
 *  Whether or not non-error logs will be dispatched asynchronously.
 */
@property (assign, nonatomic) BOOL async;

/**
 *  Whether or not error logs will be dispatched to loggers asynchronously.
 *  Default is NO
 */
@property (assign, nonatomic) BOOL errorAsync;

/**
 *  The maximum number of logs stored for real-time searching and filtering. Set to 0 to store no logs, set to NS_INTEGER_MAX to store infinite logs.
 *  Default is 1000
 */
@property (assign, nonatomic) NSInteger maxStoredLogs;

- (instancetype)initWithLoggers:(NSArray<id<SLLogger>> *)loggers NS_DESIGNATED_INITIALIZER;

/**
 *  Use a filter to return a list of stored logs that pass the filter. This will run on the search dispatch queue, which is a concurrent queue. It will return on the main queue.
 *
 *  @param searchFilterBlock The search filter that will be applied over the past logs.
 *
 *  @return An array of logs that passed the filter. Position 0 (zero) of the array contains the oldest log from the search.
 */
- (void)searchStoredLogsWithFilter:(SLLogFilterBlock)searchFilterBlock completion:(void(^)(NSArray<NSString *> *results))completionBlock;

@end

NS_ASSUME_NONNULL_END

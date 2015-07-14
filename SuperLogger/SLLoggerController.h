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
@property (copy, nonatomic, readonly) NSMutableSet<id<SLLogger>> *loggers;

/**
 *  All currently active log filters.
 */
@property (copy, nonatomic, readonly) NSMutableSet<SLLogFilterBlock> *logFilters;

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

/**
 *  The maximum number of logs stored for real-time searching and filtering. Set to 0 to store no logs, set to NS_INTEGER_MAX to store infinite logs.
 *  Default is 1000
 */
@property (assign, nonatomic) NSInteger maxStoredLogs;


- (instancetype)initWithLoggers:(NSArray<id<SLLogger>> *)loggers NS_DESIGNATED_INITIALIZER;

/**
 *  Add modules to the set of modules. This method is unneccessary, but may be useful in the future. If a log is added with an unknown module, it will automatically be added to the list of known modules.
 *
 *  @param module An array of modules to be added.
 */
- (void)addModules:(NSArray<SLClassModule *> *)module;

/**
 *  Use a filter to return a list of stored logs that pass the filter. This will run on the search dispatch queue, which is a concurrent queue. It will return on the main queue.
 *
 *  @param searchFilterBlock The search filter that will be applied over the past logs.
 *
 *  @return An array of logs that passed the filter. Position 0 (zero) of the array contains the oldest log from the search.
 */
- (void)searchStoredLogsWithFilter:(SLLogFilterBlock)searchFilterBlock completion:(void(^)(NSArray<NSString *> *results))completionBlock;

+ (dispatch_queue_t)globalLogQueue;

@end

NS_ASSUME_NONNULL_END

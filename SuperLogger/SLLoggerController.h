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

@class SLFileModule;
@class SLLog;


NS_ASSUME_NONNULL_BEGIN

@interface SLLoggerController : NSObject

/**
 *  All known log modules. Add modules early on. When a log is sent from a class that is contained in a module, the module will automatically be logged.
 */
@property (copy, nonatomic, readonly) NSSet<SLFileModule *> *logModules;

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
@property (copy, nonatomic) SLLogFormatBlock formatBlock;

/**
 *  The date formatter that will be passed to format blocks to be used on timestamps
 */
@property (strong, nonatomic) NSDateFormatter *timestampFormatter;

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
 *  Any modules that do not have an explicitly specified level will by default use the global log level;
 */
@property (assign, nonatomic) SLLogLevel globalLogLevel;

/**
 *  Shared Controller methods are class methods that automatically target the sharedController instance. Since 99% of the time you will want to use the sharedController, these are considered convenience methods.
 */
#pragma mark - Shared Controller methods

+ (SLLoggerController *)sharedController;

/**
 *  Add loggers, modules, or filters to the shared instance
 */
+ (void)addLoggers:(NSArray<id<SLLogger>> *)loggers;
+ (void)addModules:(NSArray<SLFileModule *> *)modules;
+ (void)addFilters:(NSArray<SLLogFilterBlock> *)filters;

+ (void)removeLoggers:(NSArray<id<SLLogger>> *)loggers;
+ (void)removeModules:(NSArray<SLFileModule *> *)modules;
+ (void)removeFilters:(NSArray<SLLogFilterBlock> *)filters;

/**
 *  Use a filter to return a list of stored logs that pass the filter. This will run on the search dispatch queue, which is a concurrent queue. It will return on the main queue.
 *
 *  @param searchFilterBlock The search filter that will be applied over the past logs.
 *
 *  @return An array of logs that passed the filter. Position 0 (zero) of the array contains the oldest log from the search.
 */
+ (void)searchStoredLogsWithFilters:(NSArray<SLLogFilterBlock> *)searchFilters completion:(SLSearchCompletionBlock)completionBlock;

+ (void)logWithLevel:(SLLogLevel)level
            fileName:(NSString *)fileName
        functionName:(NSString *)functionName
                line:(NSInteger)line
             message:(NSString *)message, ... NS_FORMAT_FUNCTION(5, 6);

+ (void)queueLog:(SLLog *)log;


#pragma mark - Instance Methods

- (void)addLoggers:(NSArray<id<SLLogger>> *)loggers;
- (void)addModules:(NSArray<SLFileModule *> *)modules;
- (void)addFilters:(NSArray<SLLogFilterBlock> *)filters;

- (void)removeLoggers:(NSArray<id<SLLogger>> *)loggers;
- (void)removeModules:(NSArray<SLFileModule *> *)modules;
- (void)removeFilters:(NSArray<SLLogFilterBlock> *)filters;

- (SLLogLevel)logLevelForFile:(NSString *)file;

- (void)logWithLevel:(SLLogLevel)level
            fileName:(NSString *)fileName
        functionName:(NSString *)functionName
                line:(NSInteger)line
             message:(NSString *)message, ... NS_FORMAT_FUNCTION(5, 6);

- (void)queueLog:(SLLog *)log;


#pragma mark - Shared Queue

+ (dispatch_queue_t)globalLogQueue;

@end

NS_ASSUME_NONNULL_END

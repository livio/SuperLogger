//
//  SLGlobals.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

@class SLLog;
@class SLClassModule;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, SLLogLevel) {
    SLLogLevelOff = 0,
    SLLogLevelError,
    SLLogLevelWarn,
    SLLogLevelInfo,
    SLLogLevelDebug,
    SLLogLevelVerbose,
};

/**
 *  A block run over logs to filter results into 'good' and 'bad'. 'Good' log results pass the filter and continue. 'Bad' log results are stopped at the filter.
 *
 *  @param logString The string that was passed to the log method
 *  @param level     The log level that determines the priority of the log being passed
 *  @param module    The class, or classes this log message originates from
 *
 *  @return 'YES' if the log passes the filter.
 */
typedef BOOL (^SLLogFilterBlock)(SLLog *log);

/**
 *  The search results that come from an attempted search
 *
 *  @param results An array of SLLog model objects that are the results
 *  @param error   An error if the search failed.
 *
 *  @return Whether or not the search succeeded.
 */
typedef void (^SLSearchCompletionBlock)(NSArray<SLLog *> *results, NSError **error);

/**
 *  A block that is used to format a log into a string
 *
 *  @param log The log to be formatted
 *
 *  @return The string that represents the formatted log
 */
typedef NSString __nonnull *(^SLLogFormatBlock)(SLLog *log);

NS_ASSUME_NONNULL_END

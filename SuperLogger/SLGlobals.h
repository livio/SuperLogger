//
//  SLGlobals.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

@class SLLog;
@class SLFileModule;

#define SLOG_FILE [[[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent] stringByDeletingPathExtension]
#define SLOG_FUNC [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]

NS_ASSUME_NONNULL_BEGIN

/**
 *  This enum defines the possible log levels.
 */
typedef NS_OPTIONS(NSInteger, SLLogLevel) {
    /**
     *  Nothing will be logged
     */
    SLLogLevelOff = 0,
    
    /**
     *  Log errors using this level. Logs in DEBUG and release. Logs syncronously by default. Shorthand is SLogE().
     *  If a log level is set to Error, only errors will be logged.
     */
    SLLogLevelError,
    
    /**
     *  Log anything that you want to also log in release. Logs async by default. Shorthand is SLogR().
     *  If a log level is set to Release, only errors and release logs will be logged.
     */
    SLLogLevelRelease,
    
    /**
     *  Log anything that you want to only log in DEBUG. Logs async by default. Shorthand is SLogD().
     *  If a log level is set to Debug, errors, release logs, and debug logs will be logged (in DEBUG).
     */
    SLLogLevelDebug,
    
    /**
     *  Logs only in DEBUG, extra verbose logging. Logs async by default. Shorthand is SLogV().
     *  If a log level is set to Verbose, all types of logs will be logged (in DEBUG).
     */
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
typedef void (^SLSearchCompletionBlock)(NSArray<SLLog *> *results, NSError *error);

/**
 *  A block that is used to format a log into a string
 *
 *  @param log The log to be formatted
 *  @param dateFormatter A date formatter for the timestamp.
 *
 *  @return The string that represents the formatted log
 */
typedef NSString * __nonnull (^SLLogFormatBlock)(SLLog *log,  NSDateFormatter *dateFormatter);

NS_ASSUME_NONNULL_END

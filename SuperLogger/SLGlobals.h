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

typedef NS_ENUM(NSInteger, SLLogLevel) {
    SLLogLevelVerbose = 0,
    SLLogLevelDebug,
    SLLogLevelInfo,
    SLLogLevelWarn,
    SLLogLevelError
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
 *  A block that is used to format a log into a string
 *
 *  @param log The log to be formatted
 *
 *  @return The string that represents the formatted log
 */
typedef NSString __nonnull *(^SLLogFormatBlock)(SLLog *log);

NS_ASSUME_NONNULL_END

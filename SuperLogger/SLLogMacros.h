//
//  SLLogMacros.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/23/15.
//  Copyright © 2015 livio. All rights reserved.
//


#import "SLLoggerController.h"
#import "SLGlobals.h"


#pragma mark - Debug Logs

#if DEBUG

#define SLogTrace() do { if ([SLLoggerController logLevelForFile:SLOG_FILE] >= SLLogLevelVerbose) [SLLoggerController logStringWithLevel:SLLogLevelVerbose fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:@"Trace"]; } while(0) // TODO: See if this works
#define SLogV(msg, ...) do { if ([SLLoggerController logLevelForFile:SLOG_FILE] >= SLLogLevelVerbose) [SLLoggerController logStringWithLevel:SLLogLevelVerbose fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)
#define SLogD(msg, ...) do { if ([SLLoggerController logLevelForFile:SLOG_FILE] >= SLLogLevelDebug) [SLLoggerController logStringWithLevel:SLLogLevelDebug fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)

#else

#define SLogTrace()
#define SLogV(msg, ...)
#define SLogD(msg, ...)

#endif


#pragma mark - Release Logs

#define SLogR(msg, ...) do { if ([SLLoggerController logLevelForFile:SLOG_FILE] >= SLLogLevelRelease) [SLLoggerController logStringWithLevel:SLLogLevelRelease fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)
#define SLogE(msg, ...) do { if ([SLLoggerController logLevelForFile:SLOG_FILE] >= SLLogLevelError) [SLLoggerController logStringWithLevel:SLLogLevelError fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)

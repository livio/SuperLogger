//
//  SLLogMacros.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/23/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLLoggerController.h"
#import "SLGlobals.h"

#if DEBUG

#define SLogTrace() do { if ([SLLoggerController logLevelForFile:__FILE__] >= SLLogLevelVerbose) [[SLLoggerController sharedController] logStringWithLevel:SLLogLevelVerbose fileName:__FILE__ functionName:__PRETTY_FUNCTION__ line:__LINE__ message:@"Trace"]; } while(0) // TODO: See if this works
#define SLogV(msg, ...) do { if ([SLLoggerController logLevelForFile:__FILE__] >= SLLogLevelVerbose) [[SLLoggerController sharedController] logStringWithLevel:SLLogLevelVerbose fileName:__FILE__ functionName:__PRETTY_FUNCTION__ line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)
#define SLogD(msg, ...) do { if ([SLLoggerController logLevelForFile:__FILE__] >= SLLogLevelDebug) [[SLLoggerController sharedController] logStringWithLevel:SLLogLevelDebug fileName:__FILE__ functionName:__PRETTY_FUNCTION__ line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)

#else

#define SLogTrace()
#define SLogV(msg, ...)
#define SLogD(msg, ...)

#endif

#define SLogR(msg, ...) do { if ([SLLoggerController logLevelForFile:__FILE__] >= SLLogLevelRelease) [[SLLoggerController sharedController] logStringWithLevel:SLLogLevelRelease fileName:__FILE__ functionName:__PRETTY_FUNCTION__ line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)
#define SLogE(msg, ...) do { if ([SLLoggerController logLevelForFile:__FILE__] >= SLLogLevelError) [[SLLoggerController sharedController] logStringWithLevel:SLLogLevelError fileName:__FILE__ functionName:__PRETTY_FUNCTION__ line:__LINE__ message:msg, ##__VA_ARGS__]; } while(0)

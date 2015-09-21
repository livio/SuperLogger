//
//  SLASLLogger.m
//  SuperLogger
//
//  Created by Joel Fischer on 8/26/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLASLLogger.h"

#import <asl.h>

#import "SLGlobals.h"
#import "SLLog.h"


@interface SLASLLogger ()

@property (assign, nonatomic) aslclient client;

@end

// TODO: Search?
@implementation SLASLLogger

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _logInRelease = NO;
    
    return self;
}

+ (instancetype)logger {
    return [[self alloc] init];
}


#pragma mark - SLLogger

- (BOOL)setupLogger {
    self.client = asl_open(NULL, "com.apple.console", 0);
    
    return !!self.client;
}

- (void)logWithLog:(SLLog *)log formattedLog:(NSString *)stringLog {
    int result = 0;
    const char *utf8Log = [stringLog UTF8String];
    
    // Create & set properties of the message
    aslmsg aslMsg = asl_new(ASL_TYPE_MSG);
    result += asl_set(aslMsg, ASL_KEY_MSG, utf8Log);
    
    if (result != 0) {
        // TODO: Something went wrong
    }
    
    int logLevel = [self sl_mapToASLLevelFromSLLevel:log.level];
    result = asl_log(self.client, aslMsg, logLevel, NULL);
    
    if (result != 0) {
        // TODO: something is wrong
    }
}

- (void)teardownLogger {
    asl_close(self.client);
    self.client = NULL;
}


#pragma mark - ASL Log Helpers

- (int)sl_mapToASLLevelFromSLLevel:(SLLogLevel)level {
    switch (level) {
        case SLLogLevelError: {
            return ASL_LEVEL_CRIT;
        } break;
        case SLLogLevelRelease: {
            return ASL_LEVEL_WARNING; // NSLog's level
        } break;
        case SLLogLevelDebug: // fallthrough
        case SLLogLevelVerbose: // fallthrough
        default: {
            return ASL_LEVEL_NOTICE;
        } break;
    }
}

@end

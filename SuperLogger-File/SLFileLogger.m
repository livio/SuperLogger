//
//  SLFileLogger.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/13/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLFileLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLFileLogger ()

@property (strong, nonatomic) NSFileHandle *logFile;

@end


@implementation SLFileLogger

#pragma mark - Lifecycle

- (instancetype)init {
    NSString *logFilePath = [[SLFileLogger logDirectory] stringByAppendingPathComponent:[SLFileLogger newLogFileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:logFilePath]) {
        [fileManager removeItemAtPath:logFilePath error:nil];
    }
    
    [fileManager createFileAtPath:logFilePath contents:nil attributes:nil];
    _logFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    [_logFile seekToEndOfFile];
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)logString:(NSString *)string {
    
}

+ (NSString *)newLogFileName {
    static NSString *appName = nil;
    if (!appName) {
        NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
        if (appName == nil) {
            appName = @"superlogger";
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    return [NSString stringWithFormat:@"/%@-%@.log", appName, [dateFormatter stringFromDate:[NSDate date]]];
}

+ (NSString *)logDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *logDirectory = [documentsDirectory stringByAppendingPathComponent:@"/superlogger"];
    
    return logDirectory;
}

+ (NSArray *)sl_currentLogs {
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[SLFileLogger logDirectory] error:nil];
    
    if (directoryContent == nil) {
        return @[];
    } else {
        return directoryContent;
    }
}

@end

NS_ASSUME_NONNULL_END

//
//  SLFileLogger.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/13/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLFileLogger.h"

#import "SLLog.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLFileLogger ()

@property (strong, nonatomic, nullable) NSFileHandle *logFile;

@end


@implementation SLFileLogger

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _maxNumLogFiles = 5;
    _logInRelease = NO;
    
    return self;
}

+ (instancetype)logger {
    return [[self alloc] init];
}

- (void)dealloc {
    [_logFile synchronizeFile];
    [_logFile closeFile];
}


#pragma mark - SLLogger protocol

- (BOOL)setupLogger {
    self.logFile = [self.class sl_createNewFile];
    
    if (!self.logFile) {
        return NO;
    }
    
    [self.logFile seekToEndOfFile];
    
    return YES;
}

- (void)logWithLog:(SLLog *)log formattedLog:(NSString *)stringLog {
    [self.logFile writeData:[stringLog dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)teardownLogger {
    [self.logFile synchronizeFile];
    [self.logFile closeFile];
    self.logFile = nil;
}


#pragma mark - Log Lifecycle

+ (NSString *)logDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *logDirectory = [documentsDirectory stringByAppendingPathComponent:@"/superlogger"];
    
    return logDirectory;
}

+ (NSArray *)sortedLogPaths {
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self.class logDirectory] error:nil];
    
    directoryContent = [directoryContent sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return directoryContent;
}

+ (NSString *)sl_newLogFileName {
    NSString *appBundle = nil;
    if (!appBundle) {
        appBundle = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
        if (appBundle == nil) {
            appBundle = @"superlogger";
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    
    return [NSString stringWithFormat:@"%@ %@.log", appBundle, [dateFormatter stringFromDate:[NSDate date]]];
}

- (NSFileHandle *)sl_createNewFile {
    NSString *logFilePath = [[SLFileLogger logDirectory] stringByAppendingPathComponent:[self.class sl_newLogFileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:logFilePath]) {
        [fileManager removeItemAtPath:logFilePath error:nil];
    }
    
    [fileManager createFileAtPath:logFilePath contents:nil attributes:nil];
    
    [self sl_deleteOldLogFiles];
    
    return [NSFileHandle fileHandleForWritingAtPath:logFilePath];
}

- (void)sl_deleteOldLogFiles {
    NSArray *sortedLogPaths = [self.class sortedLogPaths];
    
    if (sortedLogPaths.count <= self.maxNumLogFiles) {
        return;
    }
    
    for (int i = 0; i < (sortedLogPaths.count - self.maxNumLogFiles); i++) {
        [[NSFileManager defaultManager] removeItemAtPath:sortedLogPaths[i] error:nil];
    }
}

@end

NS_ASSUME_NONNULL_END

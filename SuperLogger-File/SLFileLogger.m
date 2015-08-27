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
    _logInRelease = YES;
    
    return self;
}

+ (instancetype)logger {
    return [[self alloc] init];
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
    [self.logFile closeFile];
    self.logFile = nil;
}


#pragma mark - Log Path Helpers

+ (NSString *)newLogFileName {
    NSString *appBundle = nil;
    if (!appBundle) {
        appBundle = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
        if (appBundle == nil) {
            appBundle = @"superlogger";
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd - HH-mm-ss";
    
    return [NSString stringWithFormat:@"/%@-%@.log", appBundle, [dateFormatter stringFromDate:[NSDate date]]];
}

+ (NSString *)logDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *logDirectory = [documentsDirectory stringByAppendingPathComponent:@"/superlogger"];
    
    return logDirectory;
}

+ (NSFileHandle *)sl_createNewFile {
    NSString *logFilePath = [[SLFileLogger logDirectory] stringByAppendingPathComponent:[SLFileLogger newLogFileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:logFilePath]) {
        [fileManager removeItemAtPath:logFilePath error:nil];
    }
    
    [fileManager createFileAtPath:logFilePath contents:nil attributes:nil];
    return [NSFileHandle fileHandleForWritingAtPath:logFilePath];
}

+ (NSArray *)sl_sortedCurrentLogs {
    NSError *error = nil;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[SLFileLogger logDirectory] error:&error];
    
    if (directoryContent == nil || error != nil) {
        return @[];
    }
    
    NSMutableArray *mutableDirectoryContent = [directoryContent mutableCopy];
    for (NSString *path in directoryContent) {
        BOOL isDirectory = NO;
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
        
        if (!exists || isDirectory) {
            [mutableDirectoryContent removeObject:path];
        }
    }
    
    directoryContent = [mutableDirectoryContent copy];
    directoryContent = [directoryContent sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return directoryContent;
}

- (void)sl_deleteOldLogFiles {
    if ([self.class sl_sortedCurrentLogs].count <= self.maxNumLogFiles) {
        return;
    }
}

@end

NS_ASSUME_NONNULL_END

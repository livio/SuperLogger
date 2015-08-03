//
//  SLClassModule.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLFileModule : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSSet<NSString *> *files;
@property (assign, nonatomic) SLLogLevel logLevel;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Initialize a file module. A file module is a group of files that, when a log comes from the file, will be utilized to decide if the log should be sent (based on the log level), and can be added as additional data (// TODO) to the log string
 *
 *  @param name  The name of the module
 *  @param files The files that are part of the module. These are strings that should match what will be returned if SLOG_FILE is run within the file (e.g. 'SLFileModule')
 *  @param level The level that will be used when deciding if a log should be run. For instance, if the global log level is 'Verbose' and a module is set to 'Error', only 'Error' logs will be logged from within that module
 *
 *  @return An instance of a module.
 */
- (instancetype)initWithName:(NSString *)name files:(NSArray<NSString *> *)files level:(SLLogLevel)level NS_DESIGNATED_INITIALIZER;

/**
 *  Initialize a file module. A file module is a group of files that, when a log comes from the file, will be utilized to decide if the log should be sent (based on the log level), and can be added as additional data (// TODO) to the log string.
 *
 *  The level is assumed to be SLLogLevelDefault (which is equivalent to whatever the global level is)
 *
 *  @param name  The name of the module
 *  @param files The files that are part of the module. These are strings that should match what will be returned if SLOG_FILE is run within the file (e.g. 'SLFileModule')
 *
 *  @return An instance of a module
 */
- (instancetype)initWithName:(NSString *)name files:(NSArray<NSString *> *)files;

/**
 *  Whether or not this module contains the specified file
 *
 *  @param fileName The file to be checked
 *
 *  @return YES or NO if the file is contained within the module
 */
- (BOOL)containsFile:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END

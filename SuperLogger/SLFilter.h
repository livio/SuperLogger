//
//  SLFilter.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/13/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"

@class SLFileModule;


@interface SLFilter : NSObject

/**
 *  If the log contains the string specified, it will not be logged.
 *
 *  @param string The string to be tested
 *
 *  @return The filter block to be added to SLLoggerController
 */
+ (SLLogFilterBlock)filterByDisallowingString:(NSString *)string;

/**
 *  Only logs containing the string specified will be logged
 *
 *  @param string The string to be tested
 *
 *  @return The filter block to be added to SLLoggerController
 */
+ (SLLogFilterBlock)filterByAllowingString:(NSString *)string;

/**
 *  If the log contains the regex specified, it will not be logged
 *
 *  @param regex The regex to be tested
 *
 *  @return The filter block to be added to SLLoggerController
 */
+ (SLLogFilterBlock)filterByDisallowingRegex:(NSRegularExpression *)regex;

/**
 *  Only logs containing the regex specified will be logged
 *
 *  @param regex The regex to be tested
 *
 *  @return The filter block to be added to SLLoggerController
 */
+ (SLLogFilterBlock)filterByAllowingRegex:(NSRegularExpression *)regex;

/**
 *  If the log contains a level lower than, or equal to, the level specified, it will be logged
 *
 *  @param level The level by which the log level will be compared
 *
 *  @return The filter block to be added to SLLoggerController
 */
+ (SLLogFilterBlock)filterByAllowingLevel:(SLLogLevel)level;

/**
 *  If the log is sent from a class that is contained in the allowed modules, it will be logged.
 *
 *  @param modules A set of modules that will be allowed
 *
 *  @return The filter block to be added to SLLoggerController
 */
+ (SLLogFilterBlock)filterByAllowingModules:(NSSet<SLFileModule *> *)modules;

/**
 *  If the log is sent from a class that is contained in the disallowed modules, it will not be logged.
 *
 *  @param modules A set of modules that will not be allowed
 *
 *  @return The filter block to be added to SLLoggerController
 */
+ (SLLogFilterBlock)filterByDisallowingModules:(NSSet<SLFileModule *> *)modules;

@end

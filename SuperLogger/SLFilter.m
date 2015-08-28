//
//  SLFilter.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/13/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLFilter.h"

#import "NSString+Utilities.h"
#import "SLFileModule.h"
#import "SLLog.h"


@implementation SLFilter

#pragma mark - String filtering

+ (SLLogFilterBlock)filterByDisallowingString:(NSString *)string caseInsensitive:(BOOL)caseInsensitive {
    return [^BOOL(SLLog *log) {
        // Return YES if it does not contain the string
        return ![log.message sl_containsString:string caseInsensitive:caseInsensitive];
    } copy];
}

+ (SLLogFilterBlock)filterByAllowingString:(NSString *)string caseInsensitive:(BOOL)caseInsensitive {
    return [^BOOL(SLLog *log) {
        // Return YES if it does contain the string
        return [log.message sl_containsString:string caseInsensitive:caseInsensitive];
    } copy];
}


#pragma mark - Regex filtering

+ (SLLogFilterBlock)filterByDisallowingRegex:(NSRegularExpression *)regex {
    return [^BOOL(SLLog *log) {
        NSUInteger matches = [regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)];
        
        // Return YES if there are no matches
        return (matches == 0);
    } copy];
}

+ (SLLogFilterBlock )filterByAllowingRegex:(NSRegularExpression *)regex {
    return [^BOOL(SLLog *log) {
        NSUInteger matches = [regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)];
        
        // Return YES if there are matches
        return (matches > 0);
    } copy];
}


#pragma mark - Log level filtering

+ (SLLogFilterBlock)filterByAllowingLevel:(SLLogLevel)level {
    return [^BOOL(SLLog *log) {
        return (log.level <= level);
    } copy];
}


#pragma mark - Class module filtering

+ (SLLogFilterBlock)filterByAllowingModules:(NSSet<SLClassModule *> *)modules {
    return [^BOOL(SLLog *log) {
        for (SLFileModule *module in modules) {
            if ([module containsFile:log.fileName]) {
                return YES;
            }
        }
        
        return NO;
    } copy];
}

+ (SLLogFilterBlock)filterByDisallowingModules:(NSSet<SLClassModule *> *)modules {
    return [^BOOL(SLLog *log) {
        for (SLFileModule *module in modules) {
            if ([module containsFile:log.fileName]) {
                return NO;
            }
        }
        
        return YES;
    } copy];
}

@end

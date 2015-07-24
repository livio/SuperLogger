//
//  SLFilter.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/13/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLFilter.h"

#import "SLClassModule.h"
#import "SLLog.h"


@implementation SLFilter

#pragma mark - String filtering

- (SLLogFilterBlock)filterByDisallowingString:(NSString *)string {
    return [^BOOL(SLLog *log) {
        return [log.message containsString:string] ? NO : YES;
    } copy];
}

- (SLLogFilterBlock)filterByAllowingString:(NSString *)string {
    return [^BOOL(SLLog *log) {
        return [log.message containsString:string] ? YES : NO;
    } copy];
}

#pragma mark - Regex filtering

- (SLLogFilterBlock)filterByDisallowingRegex:(NSRegularExpression *)regex {
    return [^BOOL(SLLog *log) {
        NSUInteger matches = [regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)];
        if (matches > 0) {
            return NO;
        } else {
            return YES;
        }
    } copy];
}

- (SLLogFilterBlock )filterByAllowingRegex:(NSRegularExpression *)regex {
    return [^BOOL(SLLog *log) {
        NSUInteger matches = [regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)];
        if (matches > 0) {
            return YES;
        } else {
            return NO;
        }
    } copy];
}


#pragma mark - Log level filtering

- (SLLogFilterBlock)filterByAllowingLevel:(SLLogLevel)level {
    return [^BOOL(SLLog *log) {
        return log.level <= level ? YES : NO;
    } copy];
}


#pragma mark - Class module filtering

- (SLLogFilterBlock)filterByAllowingModules:(NSSet<SLClassModule *> *)modules {
    return [^BOOL(SLLog *log) {
        for (SLClassModule *module in modules) {
            if ([module containsClass:log.class]) {
                return YES;
            }
        }
        
        return NO;
    } copy];
}

- (SLLogFilterBlock)filterByDisallowingModules:(NSSet<SLClassModule *> *)modules {
    return [^BOOL(SLLog *log) {
        for (SLClassModule *module in modules) {
            if ([module containsClass:log.class]) {
                return NO;
            }
        }
        
        return YES;
    } copy];
}

@end

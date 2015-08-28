//
//  NSString+Utilities.m
//  SuperLogger
//
//  Created by Joel Fischer on 8/28/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (BOOL)sl_containsString:(NSString *)string caseInsensitive:(BOOL)caseInsensitive {
    NSStringCompareOptions compareOpts = caseInsensitive ? NSCaseInsensitiveSearch : 0;
    
    return ([self rangeOfString:string options:compareOpts].location != NSNotFound);
}

@end

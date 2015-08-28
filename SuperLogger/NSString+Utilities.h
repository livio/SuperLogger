//
//  NSString+Utilities.h
//  SuperLogger
//
//  Created by Joel Fischer on 8/28/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

- (BOOL)sl_containsString:(NSString *)string caseInsensitive:(BOOL)caseInsensitive;

@end

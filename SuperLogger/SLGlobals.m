//
//  SLGlobals.m
//  SuperLogger
//
//  Created by Joel Fischer on 8/3/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"

NSString *SLLoggerDispatchQueue() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [NSString stringWithUTF8String:dispatch_queue_get_label(dispatch_get_current_queue())];
#pragma clang diagnostic pop
}

const NSInteger SLLogLevelDefault = -1;

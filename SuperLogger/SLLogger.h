//
//  SLLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"

@class SLLog;


NS_ASSUME_NONNULL_BEGIN

@protocol SLLogger <NSObject>
@required
@property (copy, nonatomic, nullable) SLLogFormatBlock formatBlock;

- (void)logString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END

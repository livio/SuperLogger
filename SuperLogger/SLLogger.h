//
//  SLLogger.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLLogger <NSObject>
@required
- (void)logString:(NSString *)string;

@end

//
//  UIDevice+IPAddress.h
//  SuperLogger
//
//  Created by Joel Fischer on 9/21/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (IPAddress)

+ (NSString *)currentIPAddressAndPreferIPv4:(BOOL)preferIPv4;
+ (NSDictionary *)allIPAddresses;

@end

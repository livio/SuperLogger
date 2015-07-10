//
//  SLClassModule.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLClassModule : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSMutableSet *classes;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name classes:(NSArray<Class> *)classes NS_DESIGNATED_INITIALIZER;

- (BOOL)containsClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END

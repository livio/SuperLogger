//
//  SLClassModule.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLClassModule.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLClassModule ()

@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSMutableSet *classes;

@end


@implementation SLClassModule

- (instancetype)init {
    NSAssert(NO, @"Cannot init this class this way. Use -[initWithName: classes:] instead");
    
    return nil;
}

- (instancetype)initWithName:(NSString *)name classes:(NSArray<Class> *)classes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = name;
    self.classes = [NSMutableSet<Class> setWithArray:classes];
    
    return self;
}

- (BOOL)containsClass:(Class)aClass {
    return [self.classes containsObject:aClass];
}

@end

NS_ASSUME_NONNULL_END

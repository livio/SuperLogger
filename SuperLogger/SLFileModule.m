//
//  SLClassModule.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import "SLFileModule.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLFileModule ()

@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSMutableSet<NSString *> *mutableFiles;

@end


@implementation SLFileModule

#pragma mark - Lifecycle

- (instancetype)init {
    NSAssert(NO, @"Cannot init this class this way. Use -[initWithName: classes:] instead");
    
    return nil;
}

- (instancetype)initWithName:(NSString *)name files:(NSArray<NSString *> *)files level:(SLLogLevel)level {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = name;
    _mutableFiles = [NSMutableSet<NSString *> setWithArray:files];
    _logLevel = level;
    
    return self;
}


#pragma mark - Set getters

- (NSSet<NSString *> *)files {
    return [NSSet setWithSet:self.mutableFiles];
}


#pragma mark - Public convenience method

- (BOOL)containsFile:(NSString *)fileName {
    return [self.files containsObject:fileName];
}

@end

NS_ASSUME_NONNULL_END

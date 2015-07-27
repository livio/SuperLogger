//
//  SLClassModule.h
//  SuperLogger
//
//  Created by Joel Fischer on 7/10/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLGlobals.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLFileModule : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSSet<NSString *> *files;
@property (assign, nonatomic) SLLogLevel logLevel;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name files:(NSArray<NSString *> *)files level:(SLLogLevel)level NS_DESIGNATED_INITIALIZER;

- (BOOL)containsFile:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END

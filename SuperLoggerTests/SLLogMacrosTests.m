//
//  SLLogMacros.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/30/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "SLLogMacros.h"

SpecBegin(SLLogMacrosTests)

xdescribe(@"Debug Macros", ^{
    // TODO
});

describe(@"Release Macros", ^{
    describe(@"Logging with the release level macro", ^{
        SLogR(@"Some test message");
    });
});

SpecEnd

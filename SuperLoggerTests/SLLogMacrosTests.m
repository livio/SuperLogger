//
//  SLLogMacros.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/30/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Foundation/Foundation.h>

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
        __block id loggerControllerClassMock = OCMClassMock([SLLoggerController class]);
        beforeAll(^{
            OCMStub([loggerControllerClassMock logLevelForFile:[OCMArg anyPointer]]).andReturn(SLLogLevelRelease);
        });
    });
});

SpecEnd

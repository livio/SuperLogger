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

describe(@"Release Macros", ^{
    describe(@"Logging with the release level macro", ^{
        context(@"when the log level is at or below release", ^{
            __block id loggerControllerClassMock = OCMClassMock([SLLoggerController class]);
            beforeAll(^{
                OCMStub([loggerControllerClassMock logLevelForFile:[OCMArg anyPointer]]).andReturn(SLLogLevelRelease);
                OCMStub([[loggerControllerClassMock ignoringNonObjectArgs] logStringWithLevel:0 fileName:[OCMArg anyPointer] functionName:[OCMArg anyPointer] line:0 message:[OCMArg any]]);
            });
            
            it(@"should log correctly", ^{
                SLogR(@"testlog");
                OCMVerify([[loggerControllerClassMock ignoringNonObjectArgs] logStringWithLevel:SLLogLevelRelease fileName:__FILE__ functionName:__PRETTY_FUNCTION__ line:0 message:@"testlog"]);
            });
        });
        
        xcontext(@"when logging is off", ^{
            __block id loggerControllerClassMock = OCMClassMock([SLLoggerController class]);
            beforeAll(^{
                OCMStub([loggerControllerClassMock logLevelForFile:[OCMArg anyPointer]]).andReturn(SLLogLevelOff);
                OCMStub([[loggerControllerClassMock ignoringNonObjectArgs] logStringWithLevel:0 fileName:[OCMArg anyPointer] functionName:[OCMArg anyPointer] line:0 message:[OCMArg any]]);
            });
            
            xit(@"should not log", ^{
                SLogR(@"testlog");
            });
        });
    });
});

SpecEnd

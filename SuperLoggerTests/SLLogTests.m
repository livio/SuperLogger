//
//  SLLogTests.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/30/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "SLLog.h"

SpecBegin(SLLogTests)

describe(@"The Log Model SLLog", ^{
    describe(@"Initializing the log", ^{
        __block SLLog *testLog = nil;
        __block NSString *someMessage = nil;
        __block NSTimeInterval someInterval = 0;
        __block SLLogLevel someLogLevel = 0;
        __block NSString *someFileName = nil;
        __block NSString *someFunctionName = nil;
        __block NSInteger someLine = 0;
        __block NSString *someQueueLabel = nil;
        __block NSArray *someCallstack = nil;
        beforeEach(^{
            someMessage = @"someMessage";
            someInterval = 2000;
            someLogLevel = SLLogLevelRelease;
            someFileName = @"someFileName";
            someFunctionName = @"someFunctionName";
            someLine = 27;
            someQueueLabel = @"com.some.test.queue";
            someCallstack = @[];
            
            testLog = [[SLLog alloc] initWithMessage:someMessage timestamp:[NSDate dateWithTimeIntervalSince1970:someInterval] level:someLogLevel fileName:someFileName functionName:someFunctionName line:someLine queueLabel:someQueueLabel callstack:someCallstack];
        });
        
        it(@"should properly return message", ^{
            expect(testLog.message).to.equal(someMessage);
        });
        
        it(@"should properly return timestamp", ^{
            expect(testLog.timestamp).to.equal([NSDate dateWithTimeIntervalSince1970:someInterval]);
        });
        
        it(@"should properly return log level", ^{
            expect(testLog.level).to.equal(someLogLevel);
        });
        
        it(@"should properly return file name", ^{
            expect(testLog.fileName).to.equal(someFileName);
        });
        
        it(@"should properly return function name", ^{
            expect(testLog.functionName).to.equal(someFunctionName);
        });
        
        it(@"should properly return line", ^{
            expect(testLog.line).to.equal(someLine);
        });
        
        it(@"should properly return queue label", ^{
            expect(testLog.queueLabel).to.equal(someQueueLabel);
        });
        
        it(@"should properly return callstack", ^{
            expect(testLog.callstack).to.equal(someCallstack);
        });
    });
    
    xdescribe(@"Getting callstack level components", ^{
        // TODO
    });
});

SpecEnd

//
//  SLLoggerControllerTests.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/28/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "SLFileModule.h"
#import "SLGlobals.h"
#import "SLLog.h"
#import "SLLogger.h"
#import "SLLoggerController.h"


SpecBegin(SLLoggerControllerTests)

describe(@"Logger Controller instance methods", ^{
    __block SLLoggerController *testController = nil;
    beforeEach(^{
        testController = [[SLLoggerController alloc] init];
    });
    
    describe(@"when initializing", ^{
        it(@"should initialize logModules", ^{
            expect(testController.logModules).notTo.beNil();
        });
        
        it(@"should have an empty logModules", ^{
            expect(testController.logModules).to.beEmpty();
        });
        
        it(@"should initialize loggers", ^{
            expect(testController.loggers).notTo.beNil();
        });
        
        it(@"should have an empty loggers", ^{
            expect(testController.loggers).to.beEmpty();
        });
        
        it(@"should initialize logFilters", ^{
            expect(testController.logFilters).notTo.beNil();
        });
        
        it(@"should have an empty logFilters", ^{
            expect(testController.logFilters).to.beEmpty();
        });
        
        it(@"should set async as YES", ^{
            expect(testController.async).to.beTruthy();
        });
        
        it(@"should set errorAsync as NO", ^{
            expect(testController.errorAsync).to.beFalsy();
        });
        
        it(@"should set globalLogLevel to debug", ^{
            expect(testController.globalLogLevel).to.equal(SLLogLevelDebug);
        });
        
        it(@"should have a default format block", ^{
            expect(testController.defaultFormatBlock).notTo.beNil();
        });
    });
    
    describe(@"when adding / removing from sets", ^{
        describe(@"when adding / removing loggers", ^{
            __block id<SLLogger> loggerMock = nil;
            beforeEach(^{
                loggerMock = OCMProtocolMock(@protocol(SLLogger));
                [testController addLoggers:@[loggerMock]];
            });
            
            describe(@"when adding a logger", ^{
                it(@"should add the logger", ^{
                    expect(testController.loggers).will.haveACountOf(1);
                    expect(testController.loggers).will.contain(loggerMock);
                });
                
                xit(@"should call setupLogger on the logger", ^{
                    // TODO
                });
                
                describe(@"if in release mode", ^{
                    xit(@"should not set up the logger if the logger should not work in release mode", ^{
                        // TODO
                    });
                });
            });
            
            describe(@"when removing a logger", ^{
                it(@"should remove the logger", ^{
                    [testController removeLoggers:@[loggerMock]];
                    expect(testController.loggers).will.haveACountOf(0);
                });
                
                xit(@"should call teardownLogger on the logger", ^{
                    
                });
            });
        });
        
        describe(@"when adding / removing logModules", ^{
            __block SLFileModule *fileModuleMock = nil;
            beforeEach(^{
                fileModuleMock = OCMClassMock([SLFileModule class]);
                [testController addModules:@[fileModuleMock]];
            });
            
            it(@"should add a fileModule", ^{
                expect(testController.logModules).will.haveACountOf(1);
                expect(testController.logModules).will.contain(fileModuleMock);
            });
            
            it(@"should remove a logger", ^{
                [testController removeModules:@[fileModuleMock]];
                expect(testController.logModules).will.haveACountOf(0);
            });
        });
        
        describe(@"when adding / removing logFilters", ^{
            __block SLLogFilterBlock filter = nil;
            beforeEach(^{
                filter = ^(SLLog *log){ return YES; };
                [testController addFilters:@[filter]];
            });
            
            it(@"should add a logger", ^{
                expect(testController.logFilters).will.haveACountOf(1);
                expect(testController.logFilters).will.contain(filter);
            });
            
            it(@"should remove a logger", ^{
                [testController removeFilters:@[filter]];
                expect(testController.logFilters).will.haveACountOf(0);
            });
        });
    });
    
    describe(@"when getting the log level for a file", ^{
        __block NSString *someFileName = nil;
        beforeAll(^{
            someFileName = @"some file";
        });
        
        context(@"when there are no log modules", ^{
            context(@"when the global log level has not been modified", ^{
                it(@"should return the global log level", ^{
                    SLLogLevel level = [testController logLevelForFile:someFileName];
                    expect(level).to.equal(testController.globalLogLevel);
                });
            });
            
            context(@"when the global log level has been modified", ^{
                beforeEach(^{
                    testController.globalLogLevel = SLLogLevelRelease;
                });
                
                it(@"should return the global log level", ^{
                    SLLogLevel level = [testController logLevelForFile:someFileName];
                    expect(level).to.equal(testController.globalLogLevel);
                });
            });
        });
        
        context(@"when there are irrelevant log modules", ^{
            __block NSString *someOtherFileName = nil;
            beforeEach(^{
                someOtherFileName = @"some other file";
                SLFileModule *irrelevantModule = [[SLFileModule alloc] initWithName:@"Irrelevant" files:@[someOtherFileName] level:SLLogLevelRelease];
                [testController addModules:@[irrelevantModule]];
                
                it(@"should return the global log level", ^{
                    SLLogLevel level = [testController logLevelForFile:someFileName];
                    expect(level).to.equal(testController.globalLogLevel);
                });
            });
        });
        
        context(@"when there is a relevant log module", ^{
            __block SLFileModule *relevantModule = nil;
            beforeEach(^{
                relevantModule = [[SLFileModule alloc] initWithName:@"Relevant" files:@[someFileName] level:SLLogLevelRelease];
                [testController addModules:@[relevantModule]];
                
                it(@"should return the global log level", ^{
                    SLLogLevel level = [testController logLevelForFile:someFileName];
                    expect(level).to.equal(relevantModule.logLevel);
                });
            });
        });
    });
    
    describe(@"when logging something", ^{
        __block id<SLLogger> testLogger = nil;
        beforeEach(^{
            [testController removeLoggers:[testController.loggers allObjects]];
            
            testLogger = OCMProtocolMock(@protocol(SLLogger));
            OCMStub([testLogger logString:[OCMArg any]]);
            
            [testController addLoggers:@[testLogger]];
        });
        
        // TODO: These verify methods seem to be failing when they shouldn't
        xit(@"should properly generate a log, and tell its loggers to log", ^{
            SLLogLevel someLogLevelDebugOrAbove = SLLogLevelRelease;
            const char *someFileName = __FILE__;
            const char *someFunctionName = __PRETTY_FUNCTION__;
            NSInteger someLine = __LINE__;
            
            OCMExpect([testLogger logString:[OCMArg any]]);
            
            [testController logStringWithLevel:someLogLevelDebugOrAbove fileName:someFileName functionName:someFunctionName line:someLine message:@"some message with format %@", @"some other message"];
            
            OCMVerifyAllWithDelay((OCMockObject *)testLogger, 0.25);
        });
        
        xit(@"should tell its loggers to log the right thing", ^{
            NSTimeInterval someInterval = 12000;
            SLLogLevel someLogLevelDebugOrAbove = SLLogLevelRelease;
            NSString *someFileName = @"testfilename";
            NSString *someFunctionName = @"testfunctionname";
            NSInteger someLine = __LINE__;
            NSString *someQueueName = @"com.test.testQueue";
            NSArray *someCallstack = @[];
            
            SLLog *testLog = [[SLLog alloc] initWithMessage:@"someString" timestamp:[NSDate dateWithTimeIntervalSince1970:someInterval] level:someLogLevelDebugOrAbove fileName:someFileName functionName:someFunctionName line:someLine queueLabel:someQueueName callstack:someCallstack];
            NSString *expectedLogString = testController.defaultFormatBlock(testLog, testController.timestampFormatter);
            
            [testController queueLog:testLog];
            OCMVerify([testLogger logString:[OCMArg any]]);
        });
    });
    
    describe(@"getting the global log queue", ^{
        __block dispatch_queue_t logQueue;
        beforeAll(^{
            logQueue = [SLLoggerController globalLogQueue];
        });
        
        it(@"should have a specific label", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            NSString *currentQueueLabel = [NSString stringWithCString:dispatch_queue_get_label(logQueue) encoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
            
            expect(currentQueueLabel).to.equal(@"com.superlogger.loggercontroller.log");
        });
    });
});

describe(@"Logger Controller class methods", ^{
    beforeEach(^{
        [[SLLoggerController sharedController] removeLoggers:[[SLLoggerController sharedController].loggers allObjects]];
        [[SLLoggerController sharedController] removeModules:[[SLLoggerController sharedController].logModules allObjects]];
        [[SLLoggerController sharedController] removeFilters:[[SLLoggerController sharedController].logFilters allObjects]];
    });
    
    it(@"should return the same object for the shared controller in multiple invocations", ^{
        expect([SLLoggerController sharedController]).to.equal([SLLoggerController sharedController]);
    });
});

SpecEnd

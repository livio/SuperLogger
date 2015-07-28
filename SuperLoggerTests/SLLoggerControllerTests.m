//
//  SLLoggerControllerTests.m
//  SuperLogger
//
//  Created by Joel Fischer on 7/28/15.
//  Copyright © 2015 livio. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "OCMock/OCMock.h"

#import "SLFileModule.h"
#import "SLGlobals.h"
#import "SLLogger.h"
#import "SLLoggerController.h"


SpecBegin(SLLoggerControllerTests)

describe(@"In the Logger Controller", ^{
    __block SLLoggerController *testController = nil;
    beforeEach(^{
        testController = [[SLLoggerController alloc] init];
    });
    
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
    
    describe(@"when adding / removing loggers", ^{
        __block id<SLLogger> logger = nil;
        beforeEach(^{
            logger = OCMProtocolMock(@protocol(SLLogger));
            [testController addLoggers:@[logger]];
        });
        
        it(@"should add a logger", ^{
            expect(testController.loggers).will.haveACountOf(1);
            expect(testController.loggers).will.contain(logger);
        });
        
        it(@"should remove a logger", ^{
            [testController removeLoggers:@[logger]];
            expect(testController.loggers).will.haveACountOf(0);
        });
    });
    
    describe(@"when adding / removing logModules", ^{
        __block SLFileModule *fileModule = nil;
        beforeEach(^{
            fileModule = OCMClassMock([SLFileModule class]);
            [testController addLoggers:@[fileModule]];
        });
        
        it(@"should add a fileModule", ^{
            expect(testController.logModules).will.haveACountOf(1);
            expect(testController.logModules).will.contain(fileModule);
        });
        
        it(@"should remove a logger", ^{
            [testController removeModules:@[fileModule]];
            expect(testController.logModules).will.haveACountOf(0);
        });
    });
    
    describe(@"when adding / removing logFilters", ^{
        __block SLLogFilterBlock filter = nil;
        beforeEach(^{
            filter = ^(SLLog *log){ return YES; };
            [testController addLoggers:@[filter]];
        });
        
        it(@"should add a logger", ^{
            expect(testController.logFilters).will.haveACountOf(1);
            expect(testController.logFilters).will.contain(filter);
        });
        
        it(@"should remove a logger", ^{
            [testController removeLoggers:@[filter]];
            expect(testController.logFilters).will.haveACountOf(0);
        });
    });
});

SpecEnd

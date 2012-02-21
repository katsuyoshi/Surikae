//
//  StopWatchTest.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/17.
//  Copyright 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "StopWatchTest.h"
#import "NSDateExtension.h"
#import "IUTSurikae.h"

static int hour, minute, second;

@implementation StopWatchTest

@synthesize stopWatch = _stopWatch;

- (void)setUp
{
    [super setUp];
    self.stopWatch = [StopWatch new];
}

- (void)tearDown
{
    self.stopWatch = nil;
    [super tearDown];
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests

- (void)timeShouldBe1Second
{
    [IUTSurikae surikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
        }
    context:^()
        {
            hour = minute = second = 0;
            [self.stopWatch start];
            second = 1;
            [self.stopWatch stop];
            ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
        }
    ];
}

- (void)timeShouldBe1SecondAfterMore1Scond
{
    [IUTSurikae surikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
        }
    context:^()
        {
            hour = minute = second = 0;
            [self.stopWatch start];
            second = 1;
            [self.stopWatch stop];
            second = 2;
            ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
        }
    ];
}

- (void)timeShouldBe1SecondEvneIfItsNotStopping
{
    [IUTSurikae surikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
        }
    context:^()
        {
            hour = minute = second = 0;
            [self.stopWatch start];
            second = 1;
            ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
        }
    ];
}

- (void)timeShouldBe1SecondEvenIfStartTwice
{
    [IUTSurikae surikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
        }
    context:^()
        {
            hour = minute = second = 0;
            [self.stopWatch start];
            second = 1;
            [self.stopWatch start];
            ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
        }
    ];
}

- (void)timeShouldBeZeroBeforeToStartForTheFirstTime
{
    [IUTSurikae surikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
        }
    context:^()
        {
            ASSERT_EQUAL_DOUBLE(0.0, self.stopWatch.time);
        }
    ];
}

- (void)timeShouldBeZeroWhenStopWithoutStarting
{
    [IUTSurikae surikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
        }
    context:^()
        {
            [self.stopWatch stop];
            ASSERT_EQUAL_DOUBLE(0.0, self.stopWatch.time);
        }
    ];
}


#pragma mark -
#pragma mark Option

// Uncomment it, if you want to test this class except other passed test classes.
//#define TESTS_ALWAYS
#ifdef TESTS_ALWAYS
- (void)testThisClassAlways { ASSERT_FAIL(@"fail always"); }
+ (BOOL)forceTestsAnyway { return YES; }
#endif

@end

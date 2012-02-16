//
//  StopWatchTest.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/17.
//  Copyright 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "StopWatchTest2.h"
#import "NSDateExtension.h"
#import "IUTSurikae.h"

/* 
 * StopWatchTest2 is same as StopWatchTest.
 * When you setup Surikae at -setUp, test codes are more simple.
 */
@implementation StopWatchTest2

@synthesize stopWatch = _stopWatch;

- (void)setUp
{
    [super setUp];
    
    // Don't forget to set global to YES
    [IUTSurikae surikaeWithClassMethod:@selector(date) originalClass:[NSDate class] mockClass:[self class] global:YES];
    
    self.stopWatch = [StopWatch new];
}

- (void)tearDown
{
    self.stopWatch = nil;
    [IUTSurikae clearAll];
    [super tearDown];
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Helpers

static int hour, minute, second;
+ (NSDate *)date
{
    return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
}

#pragma mark -
#pragma mark Tests

- (void)timeShouldBe1Second
{
    hour = minute = second = 0;
    [self.stopWatch start];
    second = 1;
    [self.stopWatch stop];
    ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
}

- (void)timeShouldBe1SecondEvneIfItsNotStopping
{
    hour = minute = second = 0;
    [self.stopWatch start];
    second = 1;
    ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
}

- (void)timeShouldBe1SecondEvenIfStartTwice
{
    hour = minute = second = 0;
    [self.stopWatch start];
    second = 1;
    [self.stopWatch start];
    ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
}

- (void)timeShouldBeZeroBeforeToStartForTheFirstTime
{
    ASSERT_EQUAL_DOUBLE(0.0, self.stopWatch.time);
}

- (void)timeShouldBeZeroWhenStopWithoutStarting
{
    [self.stopWatch stop];
    ASSERT_EQUAL_DOUBLE(0.0, self.stopWatch.time);
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

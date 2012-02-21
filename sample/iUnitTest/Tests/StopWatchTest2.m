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

@interface StopWatchTest2() {
    int hour;
    int minute;
    int second;
}
@end

@implementation StopWatchTest2

@synthesize stopWatch = _stopWatch;

- (void)setUp
{
    [super setUp];
    
    hour = minute = second = 0;

    [IUTSurikae registedSurikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^(){
        return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
    }];
    
    
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

#pragma mark -
#pragma mark Tests

- (void)timeShouldBe1Second
{
    [self.stopWatch start];
    second = 1;
    [self.stopWatch stop];
    ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
}

- (void)timeShouldBe1SecondAfterMore1Scond
{
    [self.stopWatch start];
    second = 1;
    [self.stopWatch stop];
    second = 2;
    ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
}

- (void)timeShouldBe1SecondEvneIfItsNotStopping
{
    [self.stopWatch start];
    second = 1;
    ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
}

- (void)timeShouldBe1SecondEvenIfStartTwice
{
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

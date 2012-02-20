//
//  StopWatchTest.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/17.
//  Copyright 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "StopWatchBlockTest.h"
#import "NSDateExtension.h"
#import "IUTSurikae.h"


@implementation StopWatchBlockTest

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
#pragma mark Tests

- (void)timeShouldBe1Second
{
    __block int second = 0;
 
    [IUTSurikae surikaeWithClassMethod:@selector(date) class:[NSDate class] surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:0 minute:0 second:second];
        }
     context:^()
        {
            [self.stopWatch start];
            second = 1;
            [self.stopWatch stop];
            ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
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

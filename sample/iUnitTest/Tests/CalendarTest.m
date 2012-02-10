//
//  CalendarTest.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/05.
//  Copyright 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "CalendarTest.h"
#import "IUTSurikae.h"
#import "NSDateExtension.h"


static int year;
static int month;
static int day;

@implementation CalendarTest

@synthesize calendar = _calendar;

- (void)setUp
{
    [super setUp];
    self.calendar = [[Calendar new] autorelease];
}

- (void)tearDown
{
    self.calendar = nil;
    [super tearDown];
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Helpers

+ (NSDate *)date
{
    return [NSDate dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

#pragma mark -
#pragma mark Tests

- (void)feb5thShouldBeHoliday
{
    // exchange +[NSDate date] for +[CalendarTest date]
    // Exchanged method will be retrived when IUTSurikae object was released.
    [IUTSurikae surikaeWithClassMethod:@selector(date) originalClass:[NSDate class] mockClass:[self class]];
    
    // set return value Feb. 5th
    year = 2012; month = 2; day = 5;

    // -isTodayHoliday calls +[NSDate date]. It returns Feb.5th 2012
    ASSERT(self.calendar.isTodayHoliday);
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

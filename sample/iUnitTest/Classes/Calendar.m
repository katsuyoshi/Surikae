//
//  Calendar.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/05.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Calendar.h"

@implementation Calendar

+ (NSCalendar *)gregorianCalendar
{
    return [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
}


- (BOOL)isTodayHoliday
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    return [components weekday] == 1;
}


@end

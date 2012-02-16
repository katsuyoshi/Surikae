//
//  StopWatch.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/17.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "StopWatch.h"

@interface StopWatch()
@property (retain, nonatomic) NSDate *startedAt;
@property (retain, nonatomic) NSDate *stopedAt;
@end

@implementation StopWatch

@synthesize startedAt = _startedAt;
@synthesize stopedAt = _stopedAt;

- (void)start
{
    if (self.startedAt == nil) {
        self.startedAt = [NSDate date];
        self.stopedAt = nil;
    }
}

- (void)stop
{
    if (self.startedAt) {
        self.stopedAt = [NSDate date];
    }
}

- (NSTimeInterval)time
{
    if (self.startedAt) {
        if (self.stopedAt) {
            return [self.stopedAt timeIntervalSinceDate:self.startedAt];
        } else {
            return [[NSDate date] timeIntervalSinceDate:self.startedAt];
        }
    } else {
        return 0;
    }
}

@end

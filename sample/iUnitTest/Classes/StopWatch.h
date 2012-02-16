//
//  StopWatch.h
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/17.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopWatch : NSObject

@property (readonly) NSTimeInterval time;

- (void)start;
- (void)stop;

@end

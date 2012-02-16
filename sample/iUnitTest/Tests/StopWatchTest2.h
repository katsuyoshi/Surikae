//
//  StopWatchTest2.h
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/17.
//  Copyright 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUTTest.h"
#import "StopWatch.h"


/* 
 * StopWatchTest2 is same as StopWatchTest.
 * When you setup Surikae at -setUp, test codes are more simple.
 */
@interface StopWatchTest2 : IUTTest {

}

@property (retain, nonatomic) StopWatch * stopWatch;

@end

//
//  Weather.h
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/10.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

- (void)beginGetWeather;

@property (readonly) BOOL success;

@end

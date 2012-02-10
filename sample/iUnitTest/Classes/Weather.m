//
//  Weather.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/10.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Weather.h"

@implementation Weather

@synthesize success = _success;


- (void)beginGetWeather
{
    NSURL *url = [NSURL URLWithString:@"http://weather.livedoor.com/forecast/webservice/rest/v1?city=113&day=tomorrow"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _success = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _success = NO;
}

@end

//
//  ConnectionTest.m
//  sample
//
//  Created by Ito Katsuyoshi on 12/02/10.
//  Copyright 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "WeatherTest.h"
#import "IUTSurikae.h"


@interface WeatherTest()
@property (retain, nonatomic) NSURLRequest *request;
@end

@implementation WeatherTest

@synthesize weather = _weather;
@synthesize request = _request;

static id _delegate = nil;

- (void)setUp
{
    [super setUp];
    
    _delegate = self;
    
    // If set global YES, IUTSurikae class retains exchanged methods.
    // When you want to revrive these all exchanged methods, call +[IUTSurikae cleanAl]. 
    [IUTSurikae surikaeWithClassMethod:@selector(connectionWithRequest:delegate:) originalClass:[NSURLConnection class] mockClass:[self class] global:YES];
    
    self.weather = [Weather new];
}

- (void)tearDown
{
    // Retrive all exchanged methods.
    [IUTSurikae clearAll];
    
    self.weather = nil;
    [super tearDown];
}

- (void)dealloc
{
    [super dealloc];
}

- (NSURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate
{
    self.request = request;
    // return NSURLConnection which isn't starting to connect.
    return [[[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:NO] autorelease];
}

+ (NSURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate
{
    return [_delegate connectionWithRequest:request delegate:delegate];
}



#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests

- (void)requestURLShouldBeLivedoorWeatherWebService
{
    [self.weather beginGetWeather];
    ASSERT_EQUAL(@"http://weather.livedoor.com/forecast/webservice/rest/v1?city=113&day=tomorrow", self.request.URL.absoluteString);
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

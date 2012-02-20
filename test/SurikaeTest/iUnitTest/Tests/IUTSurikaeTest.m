//
//  IUTSurikaeTest.m
//  SurikaeTest
//
//  Created by Ito Katsuyoshi on 12/02/19.
//  Copyright 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "IUTSurikaeTest.h"
#import "IUTSurikae.h"
#import "Foo.h"


@interface IUTSurikaeTest()
@property (retain, nonatomic) IUTSurikae *surikae;
@end

@implementation IUTSurikaeTest

@synthesize surikae = _surikae;


- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Helpers

+ (NSString *)foo
{
    return @"Bar";
}

- (NSString *)foo
{
    return @"bar";
}

#pragma mark -
#pragma mark Tests

- (void)classFooShouldBeFoo
{
  ASSERT_EQUAL(@"Foo", [Foo foo]);
}

- (void)classFooShouldBeBarWithMock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithClassMethod:@selector(foo) originalClass:[Foo class] mockClass:[self class]];
    ASSERT_EQUAL(@"Bar", [Foo foo]);
    [surikae release];
    ASSERT_EQUAL(@"Foo", [Foo foo]);
}

- (void)classFooShouldBeBarWithMockBlock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithClassMethod:@selector(foo) originalClass:[Foo class] block:^()
        {
            return @"Bar";
        }
    ];
    ASSERT_EQUAL(@"Bar", [Foo foo]);
    [surikae release];
    ASSERT_EQUAL(@"Foo", [Foo foo]);
}




- (void)instanceFooShouldBeFoo
{
    Foo *foo = [[Foo new] autorelease];
    ASSERT_EQUAL(@"foo", [foo foo]);
}

- (void)instanceFooShouldBeBarWithMock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithInstanceMethod:@selector(foo) originalClass:[Foo class] mockClass:[self class]];

    Foo *foo = [[Foo new] autorelease];
    ASSERT_EQUAL(@"bar", [foo foo]);
    [surikae release];
    ASSERT_EQUAL(@"foo", [foo foo]);
}

- (void)instanceFooShouldBeBarWithMockBlock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithInstanceMethod:@selector(foo) originalClass:[Foo class] block:^()
        {
            return @"bar";
        }
    ];
    Foo *foo = [[Foo new] autorelease];
    ASSERT_EQUAL(@"bar", [foo foo]);
    [surikae release];
    ASSERT_EQUAL(@"foo", [foo foo]);
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

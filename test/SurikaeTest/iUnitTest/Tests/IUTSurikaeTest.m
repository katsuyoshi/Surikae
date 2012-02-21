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

- (void)instanceFooShouldBeFoo
{
    Foo *foo = [[Foo new] autorelease];
    ASSERT_EQUAL(@"foo", [foo foo]);
}

#pragma mark - test class methods

- (void)testRegistedSurikaeWithClassNameMethodNameWithBlock
{
    [IUTSurikae registedSurikaeWithClassName:@"Foo" methodName:@"foo" surikae:^()
        {
            return @"bar";
        }
    ];
    Foo *foo = [[Foo new] autorelease];
    ASSERT_EQUAL(@"bar", [foo foo]);
    [IUTSurikae clearAll];
    // It will fail at the next test if the method was not retrieved.
}

#pragma mark - convenience methods

- (void)testSurikaeWithClassNameClassMethodNameWithLocalBlock
{
    [IUTSurikae surikaeWithClassName:@"Foo" methodName:@"+foo" surikae:^()
        {
            return @"Bar";
        }
        context:^() {
            ASSERT_EQUAL(@"Bar", [Foo foo]);
        }
    ];
    ASSERT_EQUAL(@"Foo", [Foo foo]);
}

- (void)testSurikaeWithClassNameInstanceMethodNameWithLocalBlock
{
    __block Foo *foo = [[Foo new] autorelease];
    [IUTSurikae surikaeWithClassName:@"Foo" methodName:@"-foo" surikae:^()
        {
            return @"bar";
        }
        context:^() {
            ASSERT_EQUAL(@"bar", [foo foo]);
        }
    ];
    ASSERT_EQUAL(@"foo", [foo foo]);
}

- (void)testSurikaeWithClassNameInstanceMethodNameWithMinusTypeWithLocalBlock
{
    __block Foo *foo = [[Foo new] autorelease];
    [IUTSurikae surikaeWithClassName:@"Foo" methodName:@"foo" surikae:^()
        {
            return @"bar";
        }
        context:^() {
            ASSERT_EQUAL(@"bar", [foo foo]);
        }
    ];
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

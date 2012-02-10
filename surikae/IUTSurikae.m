//
//  IUTSurikae.m
//  BCReader4PLCTest
//
//  Created by Ito Katsuyoshi on 12/02/05.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "IUTSurikae.h"

@interface IUTSurikae()
+ (void)registSurikae:(IUTSurikae *)surikae;
+ (void)unregistSurikae:(IUTSurikae *)surikae;
@end


@implementation IUTSurikae

@synthesize classMethod = _classMethod;
@synthesize originalClass = _originalClass;
@synthesize mockClass = _mockClass;
@synthesize selector = _selector;

static NSMutableArray *surikaeKamen = nil;

+ (void)initialize
{
    surikaeKamen = [NSMutableArray new];
}

+ (void)registSurikae:(IUTSurikae *)surikae
{
    [surikaeKamen addObject:surikae];
}

+ (void)unregistSurikae:(IUTSurikae *)surikae
{
    [surikaeKamen removeObject:surikae];
}

+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass global:(BOOL)global
{
    IUTSurikae *surikae = [[[self alloc] initWithClassMethod:method originalClass:originalClass mockClass:mockClass] autorelease];
    if (global) {
        [[self class] registSurikae:surikae];
    }
    return surikae;
}

+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass global:(BOOL)global
{
    IUTSurikae *surikae = [[[self alloc] initWithInstanceMethod:method originalClass:originalClass mockClass:mockClass] autorelease];
    if (global) {
        [[self class] registSurikae:surikae];
    }
    return surikae;
}


+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    return [self surikaeWithClassMethod:method originalClass:originalClass mockClass:mockClass global:NO];
}

+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    return [self surikaeWithInstanceMethod:method originalClass:originalClass mockClass:mockClass global:NO];
}

+ (void)clearAll
{
    [surikaeKamen removeAllObjects];
}


- (id)initWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    self = [self init];
    if (self) {
        _classMethod = YES;
        _selector = method;
        _originalClass = originalClass;
        _mockClass = mockClass;
        surikaeClassMethod(_originalClass, _mockClass, _selector);
    }
    return self;
}

- (id)initWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    self = [self init];
    if (self) {
        _selector = method;
        _originalClass = originalClass;
        _mockClass = mockClass;
        surikaeInstanceMethod(_originalClass, _mockClass, _selector);
    }
    return self;
}

- (void)dealloc
{
    if (_classMethod) {
        surikaeClassMethod(_originalClass, _mockClass, _selector);
    } else {
        surikaeInstanceMethod(_originalClass, _mockClass, _selector);
    }
    [super dealloc];
}

@end

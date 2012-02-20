/*
 
Copyright (c) 2012, ITO SOFT DESIGN Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
OF SUCH DAMAGE.
 
 */

#import "IUTSurikae.h"

typedef enum {
    IUTSurikaeTypeClassMethod,
    IUTSurikaeTypeInstanceMethod,
    IUTSurikaeTypeClassMethodWithBlock,
    IUTSurikaeTypeInstanceMethodWithBlock
} IUTSurikaeType;
    

@interface IUTSurikae()
{
    IUTSurikaeType _type;
    Class _originalClass;
    Class _mockClass;
    IMP _originalIMP;
    SEL _selector;
}

+ (void)registSurikae:(IUTSurikae *)surikae;
+ (void)unregistSurikae:(IUTSurikae *)surikae;
@end


@implementation IUTSurikae

#pragma mark - global life cycle

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

#pragma mark - get instance with global flag

+ (IUTSurikae *)registedSurikaeWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    return [self surikaeWithClassMethod:method originalClass:originalClass mockClass:mockClass global:YES];
}

+ (IUTSurikae *)registedSurikaeWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    return [self surikaeWithInstanceMethod:method originalClass:originalClass mockClass:mockClass global:YES];
}

+ (IUTSurikae *)registedSurikaeWithClassMethod:(SEL)method class:(Class)class block:(void *)block
{
    return [self surikaeWithClassMethod:method class:class block:block global:YES];
}

+ (IUTSurikae *)registedSurikaeWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block
{
    return [self surikaeWithInstanceMethod:method class:class block:block global:YES];
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

+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method class:(Class)class block:(void *)block global:(BOOL)global
{
    IUTSurikae *surikae = [[[self alloc] initWithClassMethod:method class:class block:block] autorelease];
    if (global) {
        [[self class] registSurikae:surikae];
    }
    return surikae;
}

+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block global:(BOOL)global
{
    IUTSurikae *surikae = [[[self alloc] initWithInstanceMethod:method class:class block:block] autorelease];
    if (global) {
        [[self class] registSurikae:surikae];
    }
    return surikae;
}


#pragma mark - get local instance

+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    return [self surikaeWithClassMethod:method originalClass:originalClass mockClass:mockClass global:NO];
}

+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    return [self surikaeWithInstanceMethod:method originalClass:originalClass mockClass:mockClass global:NO];
}

+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method class:(Class)class block:(void *)block
{
    return [self surikaeWithClassMethod:method class:class block:block global:NO];
}

+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block
{
    return [self surikaeWithInstanceMethod:method class:class block:block global:NO];
}


+ (void)surikaeWithClassMethod:(SEL)method class:(Class)class surikae:(void *)surikaeBlock context:(void (^)(void))contextBlock
{
    IUTSurikae *surikae = [[self alloc] initWithClassMethod:method class:class block:surikaeBlock];
    @try {
        contextBlock();
    } @finally {
        [surikae release];
    }
}

+ (void)surikaeWithInstanceMethod:(SEL)method class:(Class)class surikae:(void *)surikaeBlock context:(void (^)(void))contextBlock
{
    IUTSurikae *surikae = [[self alloc] initWithInstanceMethod:method class:class block:surikaeBlock];
    @try {
        contextBlock();
    } @finally {
        [surikae release];
    }
}


#pragma mark - initialize instance

- (id)initWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass
{
    self = [self init];
    if (self) {
        _type = IUTSurikaeTypeClassMethod;
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
        _type = IUTSurikaeTypeInstanceMethod;
        _selector = method;
        _originalClass = originalClass;
        _mockClass = mockClass;
        surikaeInstanceMethod(_originalClass, _mockClass, _selector);
    }
    return self;
}

- (id)initWithClassMethod:(SEL)method class:(Class)class block:(void *)block
{
    self = [self init];
    if (self) {
        _type = IUTSurikaeTypeClassMethodWithBlock;
        _selector = method;
        _originalClass = class;
        _originalIMP = surikaeClassMethodWithBlock(class, method, block);
    }
    return self;
}

- (id)initWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block
{
    self = [self init];
    if (self) {
        _type = IUTSurikaeTypeInstanceMethodWithBlock;
        _selector = method;
        _originalClass = class;
        _originalIMP = surikaeInstanceMethodWithBlock(class, method, block);
    }
    return self;
}

#pragma mark - revert

+ (void)clearAll
{
    [surikaeKamen removeAllObjects];
}

- (void)dealloc
{
    switch (_type) {
    case IUTSurikaeTypeClassMethod:
        surikaeClassMethod(_originalClass, _mockClass, _selector);
        break;
    case IUTSurikaeTypeInstanceMethod:
        surikaeInstanceMethod(_originalClass, _mockClass, _selector);
        break;
    case IUTSurikaeTypeClassMethodWithBlock:
        surikaeRetrieveClassMethodWithImp(_originalClass, _selector, _originalIMP);
        break;
    case IUTSurikaeTypeInstanceMethodWithBlock:
        surikaeRetrieveInstanceMethodWithImp(_originalClass, _selector, _originalIMP);
        break;
    }    
    [super dealloc];
}

@end

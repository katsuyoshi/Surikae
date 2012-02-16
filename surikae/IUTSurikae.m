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

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
    IUTSurikaeTypeClassMethodWithBlock,
    IUTSurikaeTypeInstanceMethodWithBlock
} IUTSurikaeType;
    

@interface IUTSurikae()
{
    IUTSurikaeType _type;
    Class _originalClass;
    IMP _originalIMP;
    SEL _selector;
}

+ (void)registSurikae:(IUTSurikae *)surikae;
+ (void)unregistSurikae:(IUTSurikae *)surikae;

- (id)initWithClassMethod:(SEL)method class:(Class)class block:(void *)block;
- (id)initWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block;

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

#pragma mark - for wide scope

+ (IUTSurikae *)registedSurikaeWithClassName:(NSString *)className methodName:(NSString *)methodName surikae:(void *)surikaeBlock
{
    IUTSurikae *surikae = [[[self alloc] initWithClassName:className methodName:methodName surikae:surikaeBlock] autorelease];
    [self registSurikae:surikae];
    return surikae;
}


#pragma mark - for local scope

+ (void)surikaeWithClassName:(NSString *)className methodName:(NSString *)methodName surikae:(void *)surikaeBlock context:(void (^)(void))contextBlock
{
    IUTSurikae *surikae = [[self alloc] initWithClassName:className methodName:methodName surikae:surikaeBlock];
    if (surikae) {
        @try {
            contextBlock();
        } @finally {
            [surikae release];
        }
    }
}


#pragma mark - initialize instance

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

- (id)initWithClassName:(NSString *)className methodName:(NSString *)methodName surikae:(void *)surikaeBlock
{
    Class class = NSClassFromString(className);
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([+-]){0,1}(.+)" options:0 error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:methodName options:0 range:NSMakeRange(0, [methodName length])];
    if (match.numberOfRanges == 3) {
        SEL selector = NSSelectorFromString([methodName substringWithRange:[match rangeAtIndex:2]]);
        NSString *type = @"-";
        NSRange range = [match rangeAtIndex:1];
        if (range.location != NSNotFound) {
            type = [methodName substringWithRange:range];
        }
        if ([type isEqualToString:@"+"]) {
            return [self initWithClassMethod:selector class:class block:surikaeBlock];
        } else
        if ([type isEqualToString:@"-"]) {
            return [self initWithInstanceMethod:selector class:class block:surikaeBlock];
        } else {
            NSString *reason = [NSString stringWithFormat:@"[%@ %@]: methodName: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), methodName];
            @throw [NSException exceptionWithName:@"IUTSurikaeException" reason:reason userInfo:nil];
        }
    } else {
        NSString *reason = [NSString stringWithFormat:@"[%@ %@]: methodName: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), methodName];
        @throw [NSException exceptionWithName:@"IUTSurikaeException" reason:reason userInfo:nil];
    }
    return nil;
}

#pragma mark - revert

+ (void)clearAll
{
    [surikaeKamen removeAllObjects];
}

- (void)dealloc
{
    switch (_type) {
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


@implementation NSObject(IUTSurikae)

+ (void)surikaeWithSelector:(SEL)selector surikae:(void *)surikaeBlock context:(void (^)(void))contextBlock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithClassMethod:selector class:self block:surikaeBlock];
    if (surikae) {
        @try {
            contextBlock();
        } @finally {
            [surikae release];
        }
    }
}

+ (void)surikaeInstanceMethod:(SEL)selector surikae:(void *)surikaeBlock context:(void (^)(void))contextBlock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithInstanceMethod:selector class:self block:surikaeBlock];
    if (surikae) {
        @try {
            contextBlock();
        } @finally {
            [surikae release];
        }
    }
}

- (void)surikaeWithSelector:(SEL)selector surikae:(void *)surikaeBlock context:(void (^)(void))contextBlock
{
    [[self class] surikaeInstanceMethod:selector surikae:surikaeBlock context:contextBlock];
}


+ (IUTSurikae *)surikaeWithSelector:(SEL)selector surikae:(void *)surikaeBlock
{
    return [[[IUTSurikae alloc] initWithClassMethod:selector class:self block:surikaeBlock] autorelease];
}

+ (IUTSurikae *)surikaeInstanceMethod:(SEL)selector surikae:(void *)surikaeBlock
{
    return [[[IUTSurikae alloc] initWithInstanceMethod:selector class:self block:surikaeBlock] autorelease];
}




+ (void)registedSurikaeWithSelector:(SEL)selector surikae:(void *)surikaeBlock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithClassMethod:selector class:self block:surikaeBlock];
    [IUTSurikae registSurikae:surikae];
    [surikae release];
}

+ (void)registedSurikaeInstanceMethod:(SEL)selector surikae:(void *)surikaeBlock
{
    IUTSurikae *surikae = [[IUTSurikae alloc] initWithInstanceMethod:selector class:self block:surikaeBlock];
    [IUTSurikae registSurikae:surikae];
    [surikae release];
}

- (void)registedSurikaeWithSelector:(SEL)selector surikae:(void *)surikaeBlock
{
    [[self class] registedSurikaeInstanceMethod:selector surikae:surikaeBlock];
}

+ (void)removeAllSurikaes
{
    [IUTSurikae clearAll];
}


@end

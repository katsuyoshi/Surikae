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

#import <Foundation/Foundation.h>
#import "surikae.h"


@interface IUTSurikae : NSObject

#pragma mark - get local instance

+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method class:(Class)class block:(void *)block;
+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block;

+ (void)surikaeWithClassName:(NSString *)className methodName:(NSString *)methodName surikae:(void *)surikaeBlock context:(void (^)(void))contextBlock;

#pragma mark - get instance with global flag

+ (IUTSurikae *)registedSurikaeWithClassMethod:(SEL)method class:(Class)class block:(void *)block;
+ (IUTSurikae *)registedSurikaeWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block;

#pragma mark - revert

+ (void)clearAll;

#pragma mark - initialize instance

- (id)initWithClassMethod:(SEL)method class:(Class)class block:(void *)block;
- (id)initWithInstanceMethod:(SEL)method class:(Class)class block:(void *)block;

- (id)initWithClassName:(NSString *)className methodName:(NSString *)methodName block:(void *)block;

@end

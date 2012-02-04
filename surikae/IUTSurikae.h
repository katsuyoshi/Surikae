//
//  IUTSurikae.h
//  BCReader4PLCTest
//
//  Created by Ito Katsuyoshi on 12/02/05.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "surikae.h"


@interface IUTSurikae : NSObject

@property (readonly, getter = isClassMethod) BOOL classMethod;
@property (readonly) Class originalClass;
@property (readonly) Class mockClass;
@property (readonly) SEL selector;

+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass;
+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass;
+ (void)clearAll;

- (id)initWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass;
- (id)initWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass;

@end

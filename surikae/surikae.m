//
//  surikae.c
//  BCReader4PLCTest
//
//  Created by Ito Katsuyoshi on 12/02/04.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//
#import "surikae.h"

void surikaeClassMethod(Class originalClass, Class mockClass, SEL selector)
{
    Method orgMethod = class_getClassMethod(originalClass, selector);
    Method mockMethod = class_getClassMethod(mockClass, selector);
    
    if (orgMethod && mockMethod) {
        IMP tmpIMP;

        tmpIMP = method_getImplementation(mockMethod);
        method_setImplementation(mockMethod, method_getImplementation(orgMethod));
        method_setImplementation(orgMethod, tmpIMP);
    }
}

void surikaeInstanceMethod(Class originalClass, Class mockClass, SEL selector)
{
    Method orgMethod = class_getInstanceMethod(originalClass, selector);
    Method mockMethod = class_getInstanceMethod(mockClass, selector);
    
    if (orgMethod && mockMethod) {
        IMP tmpIMP;

        tmpIMP = method_getImplementation(mockMethod);
        method_setImplementation(mockMethod, method_getImplementation(orgMethod));
        method_setImplementation(orgMethod, tmpIMP);
    }
}

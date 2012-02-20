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

IMP surikaeClassMethodWithBlock(Class klass, SEL selector, void *block)
{
    Method method = class_getClassMethod(klass, selector);
    IMP imp = method_getImplementation(method);
    if (block) {
        method_setImplementation(method, imp_implementationWithBlock(block));
    }
    return imp;
}

void surikaeRetrieveClassMethodWithImp(Class klass, SEL selector, IMP originalImp)
{
    Method method = class_getClassMethod(klass, selector);
    void *block = imp_getBlock(method_getImplementation(method));
    if (block) {
        imp_removeBlock(block);
    }
    method_setImplementation(method, originalImp);
}


IMP surikaeInstanceMethodWithBlock(Class klass, SEL selector, void *block)
{
    Method method = class_getInstanceMethod(klass, selector);
    IMP imp = method_getImplementation(method);
    if (block) {
        method_setImplementation(method, imp_implementationWithBlock(block));
    }
    return imp;
}

void surikaeRetrieveInstanceMethodWithImp(Class klass, SEL selector, IMP originalImp)
{
    Method method = class_getInstanceMethod(klass, selector);
    void *block = imp_getBlock(method_getImplementation(method));
    if (block) {
        imp_removeBlock(block);
    }
    method_setImplementation(method, originalImp);
}




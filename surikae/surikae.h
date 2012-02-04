//
//  surikae.h
//  BCReader4PLCTest
//
//  Created by Ito Katsuyoshi on 12/02/04.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "/usr/include/objc/objc-class.h"
#import <Foundation/Foundation.h>

void surikaeClassMethod(Class originalClass, Class mockClass, SEL selector);
void surikaeInstanceMethod(Class originalClass, Class mockClass, SEL selector);

//  NSLocale+ios8.m
//  Created by Alexey Matveev on 01.11.2014.
//  Copyright (c) 2014 Alexey Matveev. All rights reserved.

#if TARGET_IPHONE_SIMULATOR

#import "NSLocale+ios8.h"
#import <objc/runtime.h>

@implementation NSLocale (iOS8)

+ (void)load
{
    Method originalMethod = class_getClassMethod(self, @selector(currentLocale));
    Method swizzledMethod = class_getClassMethod(self, @selector(swizzled_currentLocale));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (NSLocale*)swizzled_currentLocale
{
    return [NSLocale localeWithLocaleIdentifier:LOCALE_IDENTIFIER];
}

@end

#endif
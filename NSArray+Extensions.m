//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "NSArray+Extensions.h"


@implementation NSArray (Extensions)


- (id)linq_firstOrNil:(LINQCondition)predicate
{
    for(id item in self) {
        if (predicate(item)) {
            return item;
        }
    }
    return nil;
}

@end
//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>

@interface NSArray (Extensions)

/** Returns the first item from the source array matching a predicate, or nil if there are no objects passing the test.

@param predicate The function to test each source element for a condition.
@return An item from the input sequence that satisfy the condition.
*/
- (id)linq_firstOrNil:(LINQCondition)predicate;


@end
//
// Created by Privat on 25/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "NSMutableString+Extensions.h"


@implementation NSMutableString (Extensions)

- (void)removeLastCharacter {
    [self deleteCharactersInRange:NSMakeRange([self length] - 1, 1)];
}

@end
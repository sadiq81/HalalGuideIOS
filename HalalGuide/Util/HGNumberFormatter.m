//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGNumberFormatter.h"


@implementation HGNumberFormatter {

}

+ (HGNumberFormatter *)instance {

    static HGNumberFormatter *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            [_instance setMinimumFractionDigits:2];
            [_instance setMinimumIntegerDigits:1];
        }
    }

    return _instance;
}

@end
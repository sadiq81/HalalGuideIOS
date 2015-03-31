//
// Created by Privat on 18/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGDateFormatter.h"


@implementation HGDateFormatter {

}

+ (HGDateFormatter *)instance {
    static HGDateFormatter *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            [_instance setDateFormat:@"dd-MM-yyyy"];
        }
    }

    return _instance;
}
@end
//
// Created by Privat on 12/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "MobileServices.h"


@implementation MobileServices {

}

+ (MobileServices *)instance {

    static MobileServices *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.client = [MSClient clientWithApplicationURLString:@"https://halalguide.azure-mobile.net/"
                                                    applicationKey:@"DzyawLMKsdmtXTcJTyIJjCQipurkgR22"];
        }
    }

    return _instance;
}
@end
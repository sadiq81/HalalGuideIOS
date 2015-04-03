//
// Created by Privat on 09/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>
#import "HGErrorReporting.h"


@implementation HGErrorReporting {

}

+ (HGErrorReporting *)instance {
    static HGErrorReporting *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)reportError:(NSError *)error {
    CLS_LOG(@"Error: %@", error);
}

@end

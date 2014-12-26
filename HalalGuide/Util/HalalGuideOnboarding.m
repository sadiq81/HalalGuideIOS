//
// Created by Privat on 23/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HalalGuideOnboarding.h"


@implementation HalalGuideOnboarding {

}

@synthesize defaults;

+ (HalalGuideOnboarding *)instance {
    static HalalGuideOnboarding *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.defaults = [NSUserDefaults standardUserDefaults];
        }
    }

    return _instance;
}

- (BOOL)wasOnBoardingShow:(NSString *)onBoardingKey {
    BOOL shown = [self.defaults boolForKey:onBoardingKey];
    return shown;
}

- (void)setOnBoardingShown:(NSString *)onBoardingKey {
    [self.defaults setBool:true forKey:onBoardingKey];
}

@end
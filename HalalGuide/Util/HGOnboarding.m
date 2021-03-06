//
// Created by Privat on 23/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGOnboarding.h"


@implementation HGOnboarding {

}

@synthesize defaults;

+ (HGOnboarding *)instance {
    static HGOnboarding *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.defaults = [NSUserDefaults standardUserDefaults];
        }
    }

    return _instance;
}

- (BOOL)wasOnBoardingShow:(NSString *)onBoardingKey {
#ifndef SNAPSHOT
    BOOL shown = [self.defaults boolForKey:onBoardingKey];
#else
    BOOL shown = true;
#endif
    return shown;

}

- (void)setOnBoardingShown:(NSString *)onBoardingKey {
    [self.defaults setBool:true forKey:onBoardingKey];
}

- (void)resetOnBoarding {

    [self.defaults setBool:false forKey:kAddNewOnBoardingButtonKey];
    [self.defaults setBool:false forKey:kFilterOnBoardingButtonKey];
    [self.defaults setBool:false forKey:kDiningCellPorkOnBoardingKey];
    [self.defaults setBool:false forKey:kDiningCellAlcoholOnBoardingKey];
    [self.defaults setBool:false forKey:kDiningCellHalalOnBoardingKey];

    [self.defaults setBool:false forKey:kDiningDetailAddressTelephoneOptionsOnBoardingKey];


}

@end
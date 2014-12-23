//
// Created by Privat on 23/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#define kAddNewDiningOnBoardingButtonKey @"AddNewDiningOnBoardingButton"

#import <Foundation/Foundation.h>


@interface HalalGuideOnboarding : NSObject

@property NSUserDefaults *defaults;

+ (HalalGuideOnboarding *)instance;

- (BOOL)wasOnBoardingShow:(NSString *)onBoardingKey;

- (void)setOnBoardingShown:(NSString *)onBoardingKey;
@end
//
// Created by Privat on 23/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#define kAddNewOnBoardingButtonKey @"addNewOnBoardingButton"
#define kFilterOnBoardingButtonKey @"filterOnBoardingButton"

//TODO Use new onBoarding
#define kDiningCellPorkOnBoardingKey @"diningCellPorkOnBoarding"
#define kDiningCellAlcoholOnBoardingKey @"diningCellAlcoholOnBoarding"
#define kDiningCellHalalOnBoardingKey @"diningCellHalalOnBoarding"

#define kCreateLocationPickImageOnBoardingKey @"createLocationPickImageOnBoarding"
#define kDiningDetailAddressTelephoneOptionsOnBoardingKey @"diningDetailAddressTelephoneOptionsOnBoarding"

#import <Foundation/Foundation.h>


@interface HalalGuideOnboarding : NSObject

@property NSUserDefaults *defaults;

+ (HalalGuideOnboarding *)instance;

- (BOOL)wasOnBoardingShow:(NSString *)onBoardingKey;

- (void)setOnBoardingShown:(NSString *)onBoardingKey;

- (void)resetOnBoarding;
@end
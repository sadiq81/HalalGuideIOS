//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <CMPopTipView/CMPopTipView.h>
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import "DiningTableViewCell.h"
#import "HalalGuideImageViews.h"
#import "LocationPicture.h"
#import "UIView+Extensions.h"
#import "UIImageView+WebCache.h"
#import "HalalGuideImageViews.h"
#import "HalalGuideLabels.h"
#import "HalalGuideOnboarding.h"
#import "UIView+Extensions.h"
#import "UITableViewCell+Extension.h"

@implementation DiningTableViewCell {

}

- (void)configure:(Location *)location {
    [super configure:location];


    PorkImageView *pork = (PorkImageView *) [self.contentView viewWithTag:102];
    [pork configureViewForLocation:location];

    AlcoholImageView *alcohol = (AlcoholImageView *) [self.contentView viewWithTag:103];
    [alcohol configureViewForLocation:location];

    HalalImageView *halal = (HalalImageView *) [self.contentView viewWithTag:104];
    [halal configureViewForLocation:location];

    PorkLabel *porkLabel = (PorkLabel *) [self.contentView viewWithTag:204];
    [porkLabel configureViewForLocation:location];

    AlcoholLabel *alcoholLabel = (AlcoholLabel *) [self.contentView viewWithTag:205];
    [alcoholLabel configureViewForLocation:location];

    HalalLabel *halalLabel = (HalalLabel *) [self.contentView viewWithTag:206];
    [halalLabel configureViewForLocation:location];


}

- (void)showToolTip {

    self.contentView.clipsToBounds = false;

    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellPorkOnBoardingKey]) {

        [self displayTipViewFor:[self porkImageView] withHintKey:kDiningCellPorkOnBoardingKey withDelegate:self];

    } else if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellAlcoholOnBoardingKey]) {

        [self displayTipViewFor:[self alcoholImageView] withHintKey:kDiningCellAlcoholOnBoardingKey withDelegate:self];

    } else if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellHalalOnBoardingKey]) {

        [self displayTipViewFor:[self halalImageView] withHintKey:kDiningCellHalalOnBoardingKey withDelegate:self];

    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {

    if (popTipView.targetObject == [self porkImageView]) {

        if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellAlcoholOnBoardingKey]) {
            [self displayTipViewFor:[self alcoholImageView] withHintKey:kDiningCellAlcoholOnBoardingKey withDelegate:self];
        }

    } else if (popTipView.targetObject == [self alcoholImageView]) {

        if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellHalalOnBoardingKey]) {
            [self displayTipViewFor:[self halalImageView] withHintKey:kDiningCellHalalOnBoardingKey withDelegate:self];
        }
    }
}


- (PorkImageView *)porkImageView {
    return (PorkImageView *) [self.contentView viewWithTag:102];
}

- (AlcoholImageView *)alcoholImageView {
    return (AlcoholImageView *) [self.contentView viewWithTag:103];
}

- (HalalImageView *)halalImageView {
    return (HalalImageView *) [self.contentView viewWithTag:104];
}

- (NSString *)placeholderImageName {
    return @"dining";
}


@end
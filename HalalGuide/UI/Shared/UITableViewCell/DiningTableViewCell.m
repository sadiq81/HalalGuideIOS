//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseUI/ParseUI.h>
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


@implementation DiningTableViewCell {

}

- (void)configure:(Location *)location {
    [super configure:location];


    [self.porkImageView configureViewForLocation:location];

    [self.alcoholImageView configureViewForLocation:location];

    [self.halalImageView configureViewForLocation:location];

    PorkLabel *porkLabel = (PorkLabel *) [self.contentView viewWithTag:204];
    [porkLabel configureViewForLocation:location];

    AlcoholLabel *alcoholLabel = (AlcoholLabel *) [self.contentView viewWithTag:205];
    [alcoholLabel configureViewForLocation:location];

    HalalLabel *halalLabel = (HalalLabel *) [self.contentView viewWithTag:206];
    [halalLabel configureViewForLocation:location];


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
//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "DiningTableViewCell.h"
#import "LocationPicture.h"
#import "PictureService.h"
#import "UIImageView+WebCache.h"
#import "HalalGuideImageViews.h"
#import "HalalGuideLabels.h"

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

- (NSString *)placeholderImageName {
    return @"dining";
}


@end
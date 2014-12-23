//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <EDStarRating/EDStarRating.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ParseUI/ParseUI.h>
#import "ReviewCell.h"
#import "Review.h"
#import "PictureService.h"
#import "ProfileInfo.h"
#import "ReviewDetailViewModel.h"
#import "ProfileInfoService.h"
#import "UIImageView+WebCache.h"


@implementation ReviewCell {

}

- (void)configure:(Review *)review1 {

    [[ProfileInfoService instance] profileInfoForSubmitter:review1.submitterId onCompletion:^(ProfileInfo *info) {
        [self.profileImage sd_setImageWithURL:info.facebookProfileUrl];
        self.submitterName.text = info.facebookName;
    }];

    self.rating.rating = [review1.rating floatValue];
    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];

    self.review.text = review1.review;

}


@end
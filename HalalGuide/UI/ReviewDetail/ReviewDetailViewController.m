//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "PictureService.h"
#import "LocationDetailViewModel.h"
#import "ReviewDetailViewModel.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "NSObject+RACPropertySubscribing.h"
#import "RACSignal.h"
#import "ProfileInfo.h"
#import "ProfileInfoService.h"
#import "UIImageView+WebCache.h"
#import "HalalGuideDateFormatter.h"


@implementation ReviewDetailViewController {

}

- (void)viewDidLoad {
    [self setupUIValues];
}

- (void)setupUIValues {

    [[ProfileInfoService instance] profileInfoForSubmitter:[ReviewDetailViewModel instance].review .submitterId onCompletion:^(ProfileInfo *info) {
        self.name.text = info.facebookName;
        [self.profilePicture sd_setImageWithURL:info.facebookProfileUrl];
    }];


    //TODO add category to NSDate
    self.date.text = [[HalalGuideDateFormatter instance] stringFromDate:[ReviewDetailViewModel instance].review.createdAt];
    self.reviewText.text = [ReviewDetailViewModel instance].review.review;

    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
    self.rating.rating = [[ReviewDetailViewModel instance].review.rating floatValue];
}

@end
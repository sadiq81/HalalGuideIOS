//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "LocationDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImageView+WebCache.h"
#import "HalalGuideDateFormatter.h"
#import "PFUser+Extension.h"


@implementation ReviewDetailViewController {

}

- (void)viewDidLoad {
    [self setupUIValues];
    [self setupRAC];
}

- (void)setupRAC {

    @weakify(self)
    [RACObserve(self, viewModel) subscribeNext:^(ReviewDetailViewModel *model) {
        @strongify(self)
        self.reviewText.text = model.review.review;
        self.rating.rating = model.review.rating.floatValue;
        self.date.text = [[HalalGuideDateFormatter instance] stringFromDate:model.review.createdAt];
    }];

    [RACObserve(self, viewModel.user) subscribeNext:^(PFUser *user) {
        @strongify(self)
        [self.profilePicture sd_setImageWithURL:user.facebookProfileUrlSmall];
        self.name.text = user.facebookName;
    }];

}

- (void)setupUIValues {

    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
}

@end
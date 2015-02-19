//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <EDStarRating/EDStarRating.h>
#import "ReviewCell.h"
#import "ReviewDetailViewModel.h"
#import "UIImageView+WebCache.h"
#import "PFUser+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation ReviewCell {

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureRating];
        [self configureRAC];
    }
    return self;
}

- (void)configureRAC {

    [RACObserve(self, viewModel) subscribeNext:^(ReviewDetailViewModel *model) {
        self.review.text = model.review.review;
        self.rating.rating = model.review.rating.floatValue;
    }];

    [RACObserve(self, viewModel.user) subscribeNext:^(PFUser *user) {
        [self.profileImage sd_setImageWithURL:user.facebookProfileUrlSmall];
        self.submitterName.text = user.facebookName;
    }];

}

- (void)configureRating {
    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
}

/*
- (void)updateConstraints {

    [self.profileImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.submitterName).offset(8);
        make.height.mas_equalTo(@(25));
        make.width.mas_equalTo(@(25));
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rating).offset(8);
        make.height.equalTo(self.profileImage);
    }];

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(158));
        make.right.equalTo(self.contentView).offset(8);
        make.height.equalTo(self.submitterName);
    }];

    [self.review mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.profileImage).offset(8);
        make.bottom.equalTo(self.contentView).offset(8);
    }];

    [super updateConstraints];
}
*/
@end
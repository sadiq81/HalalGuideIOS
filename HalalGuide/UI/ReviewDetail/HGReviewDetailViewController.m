//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGReviewDetailViewController.h"
#import "HGLocationDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/View+MASAdditions.h>
#import "UIImageView+WebCache.h"
#import "HGDateFormatter.h"
#import "PFUser+Extension.h"

@interface HGReviewDetailViewController ()
@property(strong, nonatomic) UIImageView *submitterImage;
@property(strong, nonatomic) UILabel *submitterName;
@property(strong, nonatomic) EDStarRating *rating;
@property(strong, nonatomic) UITextView *review;
@property(strong, nonatomic) UILabel *date;

@property(strong, nonatomic) HGReviewDetailViewModel *viewModel;

@end


@implementation HGReviewDetailViewController {

}

- (instancetype)initWithViewModel:(HGReviewDetailViewModel *)model {
    self = [super init];
    if (self) {
        self.viewModel = model;
        [self setupViews];
        [self setupRating];
        [self setupViewModel];
        [self updateViewConstraints];
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(HGReviewDetailViewModel *)model {
    return [[self alloc] initWithViewModel:model];
}


- (void)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];

    self.submitterImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.submitterImage];

    self.submitterName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.submitterName.adjustsFontSizeToFitWidth = true;
    self.submitterName.minimumScaleFactor = 0.5;
    [self.view addSubview:self.submitterName];

    self.date = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.date];

    self.rating = [[EDStarRating alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.rating];

    self.review = [[UITextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.review];
}

- (void)setupRating {

    self.rating.starImage = [UIImage imageNamed:@"HGReviewDetailViewController.star.unselected"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"HGReviewDetailViewController.star.selected"];
    self.rating.backgroundColor = [UIColor whiteColor];
}

- (void)setupViewModel {

    RAC(self.submitterName, text) = RACObserve(self, viewModel.submitterName);
    RAC(self.submitterImage, image) = RACObserve(self, viewModel.submitterImageLarge);

    RAC(self.date, text) = RACObserve(self, viewModel.date);

    RAC(self.review, text) = RACObserve(self, viewModel.reviewText);
    RAC(self.rating, rating) = RACObserve(self, viewModel.rating);
}

- (void)updateViewConstraints {

    [self.submitterImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(8);
        make.left.equalTo(self.view).offset(8);
        make.width.equalTo(@(128));
        make.height.equalTo(@(128));
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(8);
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.equalTo(@(21));
    }];

    [self.date mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterName.mas_bottom).offset(4);
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.equalTo(@(21));
    }];

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.bottom.equalTo(self.submitterImage);
        make.height.equalTo(@(21));
    }];

    [self.review mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterImage.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.bottom.equalTo(self.view).offset(-8);
    }];

    [super updateViewConstraints];
}


@end
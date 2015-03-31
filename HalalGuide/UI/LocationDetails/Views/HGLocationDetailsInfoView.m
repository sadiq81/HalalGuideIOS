//
// Created by Privat on 09/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "HGLocationDetailsInfoView.h"
#import "HGLabels.h"
#import "ReactiveCocoa.h"

@interface HGLocationDetailsInfoView ()

@property(strong) UILabel *name;
@property(strong) UILabel *road;
@property(strong) UILabel *postalCode;
@property(strong) UILabel *distance;
@property(strong) UILabel *km;
@property(strong) EDStarRating *rating;
@property(strong) UILabel *category;
@property(strong) UIImageView *porkImage;
@property(strong) UILabel *porkLabel;
@property(strong) UIImageView *alcoholImage;
@property(strong) UILabel *alcoholLabel;
@property(strong) UIImageView *halalImage;
@property(strong) UILabel *halalLabel;
@property(strong) UIImageView *languageImage;
@property(strong) UILabel *languageLabel;

@property(strong, nonatomic) LocationDetailViewModel *viewModel;
@end

@implementation HGLocationDetailsInfoView {

}

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
        [self setupViewModel];
    }

    return self;
}

+ (instancetype)viewWithViewModel:(LocationDetailViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

-(void)setupViews{
    self.name = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:17];
    [self addSubview:self.name];

    self.road = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:14];
    [self addSubview:self.road];

    self.postalCode = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:14];
    [self addSubview:self.postalCode];

    self.rating = [[EDStarRating alloc] initWithFrame:CGRectZero];
    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.displayMode = EDStarRatingDisplayHalf;
    self.rating.backgroundColor = [UIColor clearColor];
    self.rating.horizontalMargin = 0;
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
    self.rating.rating = 0;
    [self addSubview:self.rating];

    self.category = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    [self addSubview:self.category];

    self.distance = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    [self addSubview:self.distance];
    self.km = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.km.text = NSLocalizedString(@"LocationDetailViewController.label.km", nil);
    [self addSubview:self.km];

    self.porkImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.porkImage];
    self.porkLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self addSubview:self.porkLabel];

    self.alcoholImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.alcoholImage];
    self.alcoholLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self addSubview:self.alcoholLabel];

    self.halalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.halalImage];
    self.halalLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self addSubview:self.halalLabel];
}

-(void)setupViewModel{

    RAC(self.name, text) = RACObserve(self, viewModel.location.name);
    RAC(self.distance, text) = RACObserve(self, viewModel.distance);
    RAC(self.road, text) = RACObserve(self, viewModel.address);
    RAC(self.postalCode, text) = RACObserve(self, viewModel.postalCode);
    RAC(self.rating, rating) = RACObserve(self, viewModel.rating);

    RAC(self.category, text) = RACObserve(self, viewModel.category);

    RAC(self.porkImage, image) = RACObserve(self, viewModel.porkImage);
    RAC(self.alcoholImage, image) = RACObserve(self, viewModel.alcoholImage);
    RAC(self.halalImage, image) = RACObserve(self, viewModel.halalImage);

    RAC(self.porkLabel, attributedText) = RACObserve(self, viewModel.porkString);
    RAC(self.alcoholLabel, attributedText) = RACObserve(self, viewModel.alcoholString);
    RAC(self.halalLabel, attributedText) = RACObserve(self, viewModel.halalString);

    RAC(self.languageImage, image) = RACObserve(self, viewModel.languageImage);
    RAC(self.languageLabel, text) = RACObserve(self, viewModel.languageString);
}

- (void)updateConstraints {

    self.translatesAutoresizingMaskIntoConstraints = false;

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
    }];

    [self.road mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(4);
        make.left.equalTo(self).offset(8);
    }];
    [self.postalCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.road.mas_bottom).offset(4);
        make.left.equalTo(self).offset(8);
    }];

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.postalCode.mas_bottom).offset(8);
        make.left.equalTo(self).offset(8);
        make.width.equalTo(self.rating.mas_height).multipliedBy(5);
        make.height.equalTo(@(20));
    }];

    [self.category mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rating.mas_bottom).offset(4);
        make.bottom.equalTo(self.porkLabel.mas_bottom);
        make.left.equalTo(self.mas_left).offset(8);
    }];

    [self.distance mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(8);
    }];

    [self.km mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self.distance.mas_bottom).offset(4);
    }];

    [self.porkImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alcoholImage.mas_top);
        make.right.equalTo(self.alcoholImage.mas_left).offset(-8);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [self.porkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.porkImage);
        make.top.equalTo(self.porkImage.mas_bottom).offset(8);
    }];

    [self.alcoholImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.halalImage.mas_top);
        make.right.equalTo(self.halalImage.mas_left).offset(-8);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [self.alcoholLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alcoholImage);
        make.top.equalTo(self.alcoholImage.mas_bottom).offset(8);
    }];

    [self.halalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rating.mas_bottom);
        make.right.equalTo(self).offset(-8);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [self.halalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.halalImage);
        make.top.equalTo(self.halalImage.mas_bottom).offset(8);
    }];

    [super updateConstraints];
}


@end
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
@property(strong) UIImageView *alcoholImage;
@property(strong) UIImageView *halalImage;
@property(strong) UIImageView *languageImage;
@property(strong) UILabel *languageLabel;

@property(strong, nonatomic) HGLocationDetailViewModel *viewModel;
@end

@implementation HGLocationDetailsInfoView {

}

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
        [self setupViewModel];
    }

    return self;
}

+ (instancetype)viewWithViewModel:(HGLocationDetailViewModel *)viewModel {
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
    self.rating.starImage = [[UIImage imageNamed:@"HGLocationDetailsInfoView.star.unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.rating.displayMode = EDStarRatingDisplayHalf;
    self.rating.backgroundColor = [UIColor clearColor];
    self.rating.horizontalMargin = 0;
    self.rating.starHighlightedImage = [[UIImage imageNamed:@"HGLocationDetailsInfoView.star.selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.rating.rating = 0;
    [self addSubview:self.rating];

    self.category = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    [self addSubview:self.category];

    self.distance = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    [self addSubview:self.distance];
    self.km = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.km.text = NSLocalizedString(@"HGLocationDetailsInfoView.label.km", nil);
    [self addSubview:self.km];

    self.porkImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.porkImage setTintColor:[UIColor redColor]];
    [self addSubview:self.porkImage];

    self.alcoholImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.alcoholImage setTintColor:[UIColor redColor]];
    [self addSubview:self.alcoholImage];

    self.halalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.halalImage setTintColor:[UIColor redColor]];
    [self addSubview:self.halalImage];

    self.languageImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.languageImage];
    self.languageLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self addSubview:self.languageLabel];
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
        make.bottom.equalTo(self.rating.mas_bottom);
        make.right.equalTo(self.alcoholImage.mas_left).offset(self.viewModel.alcoholImage ?  -8 : 0);
        make.width.equalTo(@(self.viewModel.porkImage ? 31 : 0));
        make.height.equalTo(@(self.viewModel.porkImage ? 31 : 0));
    }];

    [self.alcoholImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rating.mas_bottom);
        make.right.equalTo(self.halalImage.mas_left).offset(self.viewModel.halalImage ?  -8 : 0);
        make.width.equalTo(@(self.viewModel.alcoholImage ? 31 : 0));
        make.height.equalTo(@(self.viewModel.alcoholImage ? 31 : 0));
    }];

    [self.halalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rating.mas_bottom);
        make.right.equalTo(self).offset(-8);
        make.width.equalTo(@(self.viewModel.halalImage ? 31 : 0));
        make.height.equalTo(@(self.viewModel.halalImage ? 31 : 0));
    }];

    if (self.viewModel.location.locationType.intValue == LocationTypeMosque){

        [self.languageImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.rating.mas_bottom);
            make.right.equalTo(self).offset(-8);
            make.width.equalTo(@(31));
            make.height.equalTo(@(31));
        }];

        [self.languageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.languageImage);
            make.top.equalTo(self.languageImage.mas_bottom).offset(8);
        }];
    }

    [super updateConstraints];
}


@end
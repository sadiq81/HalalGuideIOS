//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import <Masonry/View+MASAdditions.h>
#import "DiningCell.h"
#import "HGImageViews.h"
#import "LocationPicture.h"
#import "UIView+Extensions.h"
#import "UIImageView+WebCache.h"
#import "HGImageViews.h"
#import "HGLabels.h"
#import "HGOnboarding.h"
#import "UIView+Extensions.h"

@interface DiningCell ()

@property(strong, nonatomic) UIImageView *porkImage;
@property(strong, nonatomic) UIImageView *alcoholImage;
@property(strong, nonatomic) UIImageView *halalImage;

@property(strong, nonatomic) UILabel *porkLabel;
@property(strong, nonatomic) UILabel *alcoholLabel;
@property(strong, nonatomic) UILabel *halalLabel;
@end

@implementation DiningCell {

}

- (void)setupViews {
    [super setupViews];

    self.porkImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.porkImage];

    self.alcoholImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.alcoholImage];

    self.halalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.halalImage];

    self.porkLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.porkLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.porkLabel];

    self.alcoholLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.alcoholLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.alcoholLabel];

    self.halalLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.halalLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.halalLabel];
}

- (void)setupViewModel {
    [super setupViewModel];

    RAC(self.porkImage, image) = RACObserve(self, viewModel.porkImage);
    RAC(self.alcoholImage, image) = RACObserve(self, viewModel.alcoholImage);
    RAC(self.halalImage, image) = RACObserve(self, viewModel.halalImage);

    RAC(self.porkLabel, attributedText) = RACObserve(self, viewModel.porkString);
    RAC(self.alcoholLabel, attributedText) = RACObserve(self, viewModel.alcoholString);
    RAC(self.halalLabel, attributedText) = RACObserve(self, viewModel.halalString);

}

- (void)updateConstraints {

    [self.halalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
        make.right.equalTo(self.distance.mas_left).offset(-standardCellSpacing);
    }];

    [self.halalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.halalImage);
        make.width.equalTo(@(31));
        make.height.equalTo(@(13));
        make.bottom.equalTo(self.contentView).offset(-standardCellSpacing);
    }];

    [self.alcoholImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
        make.right.equalTo(self.halalImage.mas_left).offset(-standardCellSpacing);
    }];

    [self.alcoholLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alcoholImage);
        make.width.equalTo(@(31));
        make.height.equalTo(@(13));
        make.bottom.equalTo(self.contentView).offset(-standardCellSpacing);
    }];

    [self.porkImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
        make.right.equalTo(self.alcoholImage.mas_left).offset(-standardCellSpacing);
    }];

    [self.porkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.porkImage);
        make.width.equalTo(@(31));
        make.height.equalTo(@(13));
        make.bottom.equalTo(self.contentView).offset(-standardCellSpacing);
    }];

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.porkImage.mas_left).offset(-standardCellSpacing);
    }];

    [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.porkImage.mas_left).offset(-standardCellSpacing);
    }];

    [super updateConstraints];
}

+ (NSString *)placeholderImageName {
    return @"dining";
}

@end
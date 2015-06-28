//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Masonry/View+MASAdditions.h>
#import "HGDiningCell.h"

@interface HGDiningCell ()

@property(strong, nonatomic) UIImageView *porkImage;
@property(strong, nonatomic) UIImageView *alcoholImage;
@property(strong, nonatomic) UIImageView *halalImage;

@end

@implementation HGDiningCell {

}

- (void)setupViews {
    [super setupViews];

    self.porkImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.porkImage setTintColor:[UIColor redColor]];
    [self.contentView addSubview:self.porkImage];

    self.alcoholImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.alcoholImage setTintColor:[UIColor redColor]];
    [self.contentView addSubview:self.alcoholImage];

    self.halalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.halalImage setTintColor:[UIColor redColor]];
    [self.contentView addSubview:self.halalImage];

}

- (void)setupViewModel {
    [super setupViewModel];

    RAC(self.porkImage, image) = RACObserve(self, viewModel.porkImage);
    RAC(self.alcoholImage, image) = RACObserve(self, viewModel.alcoholImage);
    RAC(self.halalImage, image) = RACObserve(self, viewModel.halalImage);

    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        [self updateConstraints];
    }];

}

- (void)updateConstraints {

    [self.halalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.width.equalTo(@(12));
        make.height.equalTo(@(self.viewModel.halalImage ? 12 : 0));
        make.right.equalTo(self.distance.mas_left).offset(-standardCellSpacing);
    }];

    [self.alcoholImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.halalImage.mas_bottom).offset(self.viewModel.halalImage ? 5 : 0);
        make.width.equalTo(@(12));
        make.height.equalTo(@(self.viewModel.alcoholImage ? 12 : 0));
        make.right.equalTo(self.distance.mas_left).offset(-standardCellSpacing);
    }];

    [self.porkImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alcoholImage.mas_bottom).offset(self.viewModel.alcoholImage ? 5 : 0);
        make.width.equalTo(@(12));
        make.height.equalTo(@(self.viewModel.porkImage ? 12 : 0));
        make.right.equalTo(self.distance.mas_left).offset(-standardCellSpacing);
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
    return kDiningImageIdentifier;
}

+ (NSString *)reuseIdentifier {
    return kDiningReuseIdentifier;
}

@end
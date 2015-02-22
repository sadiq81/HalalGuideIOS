//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import <Masonry/View+MASAdditions.h>
#import "DiningCell.h"
#import "HalalGuideImageViews.h"
#import "LocationPicture.h"
#import "UIView+Extensions.h"
#import "UIImageView+WebCache.h"
#import "HalalGuideImageViews.h"
#import "HalalGuideLabels.h"
#import "HalalGuideOnboarding.h"
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.porkImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.porkImage];

        self.alcoholImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.alcoholImage];

        self.halalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.halalImage];

        self.porkLabel = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
        self.porkLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.porkLabel];

        self.alcoholLabel = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
        self.alcoholLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.alcoholLabel];

        self.halalLabel = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
        self.halalLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.halalLabel];

        @weakify(self)
        [[RACObserve(self, viewModel) ignore:nil] subscribeNext:^(LocationDetailViewModel *viewModel) {
            @strongify(self)

            self.porkImage.image = [UIImage imageNamed:viewModel.location.pork.boolValue ? @"PigTrue" : @"PigFalse"];
            self.alcoholImage.image = [UIImage imageNamed:viewModel.location.alcohol.boolValue ? @"AlcoholTrue" : @"AlcoholFalse"];
            self.halalImage.image = [UIImage imageNamed:viewModel.location.nonHalal.boolValue ? @"NonHalalTrue" : @"NonHalalFalse"];

            self.porkLabel.attributedText = [self stringForBool:self.viewModel.location.pork.boolValue];
            self.alcoholLabel.attributedText = [self stringForBool:self.viewModel.location.alcohol.boolValue];
            self.halalLabel.attributedText = [self stringForBool:self.viewModel.location.nonHalal.boolValue];

        }];
    }

    return self;
}

- (NSMutableAttributedString *)stringForBool:(BOOL)value {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:value ? NSLocalizedString(@"yes", nil) : NSLocalizedString(@"no", nil)];
    [string addAttribute:NSForegroundColorAttributeName value:value ? [UIColor redColor] : [UIColor greenColor] range:NSMakeRange(0, [string.mutableString length])];
    return string;
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
        make.bottom.equalTo(self.postalCode.mas_bottom);
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

    [self.postalCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.porkImage.mas_left).offset(-standardCellSpacing);
    }];


    [super updateConstraints];
}

+ (NSString *)placeholderImageName {
    return @"dining";
}

@end
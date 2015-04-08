//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGMosqueCell.h"
#import "HGPictureService.h"
#import "HGLocationPicture.h"
#import "UIImageView+WebCache.h"
#import "HGLocation.h"

@interface HGMosqueCell ()

@property(nonatomic, strong) UIImageView *languageImage;
@property(nonatomic, strong) UILabel *languageLabel;

@end

@implementation HGMosqueCell {

}


- (void)setupViews {
    [super setupViews];

    self.languageImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.languageImage];

    self.languageLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    self.languageLabel.adjustsFontSizeToFitWidth = true;
    self.languageLabel.minimumScaleFactor = 0.5;
    [self.contentView addSubview:self.languageLabel];
}

- (void)setupViewModel {
    [super setupViewModel];

    RAC(self.languageImage, image) = RACObserve(self, viewModel.languageImage);
    RAC(self.languageLabel, text) = RACObserve(self, viewModel.languageString);
}


- (void)updateConstraints {

    [self.languageImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
        make.right.equalTo(self.distance.mas_left).offset(-standardCellSpacing);
    }];

    [self.languageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.languageImage);
        make.width.equalTo(@(31));
        make.height.equalTo(@(13));
        make.top.equalTo(self.languageImage.mas_bottom).offset(4);
    }];

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.languageImage.mas_left).offset(-standardCellSpacing);
    }];

    [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.languageImage.mas_left).offset(-standardCellSpacing);
    }];

    [super updateConstraints];
}

+ (NSString *)placeholderImageName {
    return kMosqueImageIdentifier;
}

+(NSString *)reuseIdentifier {
    return kMosqueReuseIdentifier;
}

@end
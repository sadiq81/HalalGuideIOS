//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "LocationCell.h"
#import "UIImageView+WebCache.h"
#import "PictureService.h"
#import "HalalGuideNumberFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AddressService.h"

@interface LocationCell ()
@property(nonatomic, strong) UIImageView *thumbnail;
@property(nonatomic, strong) UILabel *distance;
@property(nonatomic, strong) UILabel *km;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *address;
@property(nonatomic, strong) UILabel *postalCode;
@property(nonatomic, strong) UILabel *open;
@property(nonatomic, strong) LocationDetailViewModel *viewModel;
@end

@implementation LocationCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.thumbnail.image = [UIImage imageNamed:[[self class] placeholderImageName]];
        [self.contentView addSubview:self.thumbnail];

        self.distance = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:13];
        self.distance.textAlignment = NSTextAlignmentRight;
        self.distance.adjustsFontSizeToFitWidth = true;
        self.distance.minimumScaleFactor = 0.5;
        [self.contentView addSubview:self.distance];

        self.km = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
        self.km.text = @"km";
        self.km.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.km];

        self.name = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:13];
        self.name.adjustsFontSizeToFitWidth = true;
        self.name.minimumScaleFactor = 0.5;
        [self.contentView addSubview:self.name];

        self.address = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
        self.address.adjustsFontSizeToFitWidth = true;
        self.address.minimumScaleFactor = 0.5;
        [self.contentView addSubview:self.address];

        self.postalCode = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
        self.postalCode.adjustsFontSizeToFitWidth = true;
        self.postalCode.minimumScaleFactor = 0.5;
        [self.contentView addSubview:self.postalCode];
//
//        self.open = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
//        self.open.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:self.open];
        RAC(self.name, text) = RACObserve(self, viewModel.location.name);
        RAC(self.distance, text) = RACObserve(self, viewModel.distance);
        RAC(self.address, text) = RACObserve(self, viewModel.address);
        RAC(self.postalCode, text) = RACObserve(self, viewModel.postalCode);
        RAC(self.thumbnail, image, [UIImage imageNamed:[[self class]placeholderImageName]]) = RACObserve(self, viewModel.thumbnail);

        [self setNeedsUpdateConstraints];

    }
    return self;
}

- (void)configureForViewModel:(LocationDetailViewModel *)viewModel {
    self.viewModel = viewModel;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnail.image = [UIImage imageNamed:[[self class] placeholderImageName]];
    [self.thumbnail sd_cancelCurrentImageLoad];
}

static const int standardLabelWidth = 100;

- (void)updateConstraints {

    [self.thumbnail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.left.equalTo(self.contentView).offset(standardCellSpacing);
        make.width.equalTo(@(48));
        make.height.equalTo(@(48));
    }];

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.left.equalTo(self.thumbnail.mas_right).offset(standardCellSpacing);
        make.height.equalTo(@(16));
    }];

    [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(4);
        make.left.equalTo(self.thumbnail.mas_right).offset(standardCellSpacing);
        make.height.equalTo(@(14));
    }];

    [self.postalCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.address.mas_bottom);
        make.left.equalTo(self.thumbnail.mas_right).offset(standardCellSpacing);
        make.height.equalTo(@(14));
    }];

    [self.distance mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.right.equalTo(self.contentView).offset(-standardCellSpacing);
        make.height.equalTo(@(13));
        make.width.lessThanOrEqualTo(@(30));
    }];

    [self.km mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distance.mas_bottom);
        make.right.equalTo(self.contentView).offset(-standardCellSpacing);
        make.height.equalTo(@(13));
    }];
//
//    [self.open mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView).offset(-standardCellSpacing);
//        make.right.equalTo(self.contentView).offset(-standardCellSpacing);
//        make.height.equalTo(@(13));
//    }];

    [super updateConstraints];
}

+ (NSString *)placeholderImageName {
    @throw @"Should be overriden";
}

@end

//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGLocationCell.h"
#import "HGLabels.h"
#import "HGReachabilityManager.h"
#import "HGColor.h"


@interface HGLocationCell ()
@property(nonatomic, strong) AsyncImageView *thumbnail;
@property(nonatomic, strong) UILabel *distance;
@property(nonatomic, strong) UILabel *km;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *address;
@property(nonatomic, strong) UILabel *postalCode;
@property(nonatomic, strong) UILabel *open;
@property(nonatomic, strong) HGLocationDetailViewModel *viewModel;
@end

@implementation HGLocationCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupViewModel];
        [self setNeedsUpdateConstraints];

    }
    return self;
}

- (void)setupViews {
    self.thumbnail = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    self.thumbnail.image = [[UIImage imageNamed:[[self class] placeholderImageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.thumbnail.tintColor = [HGColor greenTintColor];

    if (![HGReachabilityManager isReachable]) {
        self.thumbnail.showActivityIndicator = false;
    }

    self.thumbnail.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    [self.contentView addSubview:self.thumbnail];

    //TODO update label when current position changes, perhaps using NSNotification
    self.distance = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    self.distance.textAlignment = NSTextAlignmentRight;
    self.distance.adjustsFontSizeToFitWidth = true;
    self.distance.minimumScaleFactor = 0.5;
    [self.contentView addSubview:self.distance];

    self.km = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.km.text = @"km";
    self.km.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.km];

    self.name = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    self.name.adjustsFontSizeToFitWidth = true;
    self.name.minimumScaleFactor = 0.5;
    [self.contentView addSubview:self.name];

    self.address = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.address.adjustsFontSizeToFitWidth = true;
    self.address.minimumScaleFactor = 0.5;
    [self.contentView addSubview:self.address];

    self.postalCode = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    self.postalCode.adjustsFontSizeToFitWidth = true;
    self.postalCode.minimumScaleFactor = 0.5;
    [self.contentView addSubview:self.postalCode];
//
//        self.open = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:10];
//        self.open.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:self.open];
}

- (void)updateLocationDistance {

}

- (void)setupViewModel {

    RAC(self.name, text) = RACObserve(self, viewModel.location.name);
    RAC(self.distance, text) = RACObserve(self, viewModel.distance);
    RAC(self.address, text) = RACObserve(self, viewModel.address);
    RAC(self.postalCode, text) = RACObserve(self, viewModel.postalCode);
    RAC(self.thumbnail, imageURL) = [RACObserve(self, viewModel.thumbnail) ignore:nil];
}

- (void)configureForViewModel:(HGLocationDetailViewModel *)viewModel {
    self.viewModel = viewModel;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnail.image = [[UIImage imageNamed:[[self class] placeholderImageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)updateConstraints {

    [self.thumbnail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(standardCellSpacing);
        make.left.equalTo(self.contentView).offset(standardCellSpacing);
        make.width.equalTo(@(48));
        make.height.equalTo(@(48));
    }];

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.address.mas_top).offset(-4);
        make.left.equalTo(self.thumbnail.mas_right).offset(standardCellSpacing);
        make.height.equalTo(@(16));
    }];

    [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.postalCode.mas_top).offset(-2);
        make.left.equalTo(self.thumbnail.mas_right).offset(standardCellSpacing);
        make.height.equalTo(@(14));
    }];

    [self.postalCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-standardCellSpacing);
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



+ (NSString *)reuseIdentifier {
    @throw @"Should be overriden";
}


@end

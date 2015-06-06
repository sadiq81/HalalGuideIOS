//
// Created by Privat on 31/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGCreateSwitchView.h"

@interface HGCreateSwitchView ()

@property(strong, nonatomic) UIImageView *halalImage;
@property(strong, nonatomic) SevenSwitch *halalSwitch;
@property(strong, nonatomic) UILabel *halalLabel;

@property(strong, nonatomic) UIImageView *alcoholImage;
@property(strong, nonatomic) SevenSwitch *alcoholSwitch;
@property(strong, nonatomic) UILabel *alcoholLabel;

@property(strong, nonatomic) UIImageView *porkImage;
@property(strong, nonatomic) SevenSwitch *porkSwitch;
@property(strong, nonatomic) UILabel *porkLabel;

@property(strong, nonatomic) HGCreateLocationViewModel *viewModel;

@end

@implementation HGCreateSwitchView {

}

- (id)initWithViewModel:(HGCreateLocationViewModel *)model {
    self = [super init];
    if (self) {
        self.viewModel = model;
        [self setupViews];
        [self setupViewModel];
        [self updateConstraints];
    }
    return self;
}

- (void)setupViews {

    self.halalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.halalImage.image = [UIImage imageNamed:@"HGCreateSwitchView.non.halal.false"];
    [self addSubview:self.halalImage];

    self.halalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.halalLabel.text = NSLocalizedString(@"HGCreateSwitchView.label.halal", nil);
    self.halalLabel.adjustsFontSizeToFitWidth = true;
    self.halalLabel.minimumScaleFactor = 0.5;
    [self addSubview:self.halalLabel];

    self.halalSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    self.halalSwitch.onLabel.text = NSLocalizedString(@"HGCreateSwitchView.switch.on", nil);
    self.halalSwitch.offLabel.text = NSLocalizedString(@"HGCreateSwitchView.switch.off", nil);
    self.halalSwitch.onTintColor = [UIColor redColor];
    self.halalSwitch.inactiveColor = [UIColor greenColor];
    [self addSubview:self.halalSwitch];

    self.alcoholImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.alcoholImage.image = [UIImage imageNamed:@"HGCreateSwitchView.alcohol.false"];
    [self addSubview:self.alcoholImage];

    self.alcoholLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.alcoholLabel.text = NSLocalizedString(@"HGCreateSwitchView.label.alcohol", nil);
    self.alcoholLabel.adjustsFontSizeToFitWidth = true;
    self.alcoholLabel.minimumScaleFactor = 0.5;
    [self addSubview:self.alcoholLabel];

    self.alcoholSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    self.alcoholSwitch.onLabel.text = NSLocalizedString(@"HGCreateSwitchView.switch.on", nil);
    self.alcoholSwitch.offLabel.text = NSLocalizedString(@"HGCreateSwitchView.switch.off", nil);
    self.alcoholSwitch.onTintColor = [UIColor redColor];
    self.alcoholSwitch.inactiveColor = [UIColor greenColor];
    [self addSubview:self.alcoholSwitch];

    self.porkImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.porkImage.image = [UIImage imageNamed:@"HGCreateSwitchView.pork.false"];
    [self addSubview:self.porkImage];

    self.porkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.porkLabel.text = NSLocalizedString(@"HGCreateSwitchView.label.pork", nil);
    self.porkLabel.adjustsFontSizeToFitWidth = true;
    self.porkLabel.minimumScaleFactor = 0.5;
    [self addSubview:self.porkLabel];

    self.porkSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    self.porkSwitch.onLabel.text = NSLocalizedString(@"HGCreateSwitchView.switch.on", nil);
    self.porkSwitch.offLabel.text = NSLocalizedString(@"HGCreateSwitchView.switch.off", nil);
    self.porkSwitch.onTintColor = [UIColor redColor];
    self.porkSwitch.inactiveColor = [UIColor greenColor];
    [self addSubview:self.porkSwitch];
}

- (void)setupViewModel {

    RAC(self.viewModel, nonHalal) = RACObserve(self, halalSwitch.on);
    RAC(self.viewModel, alcohol) = RACObserve(self, alcoholSwitch.on);
    RAC(self.viewModel, pork) = RACObserve(self, porkSwitch.on);

    @weakify(self)
    [[self.porkSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.porkImage.image = [UIImage imageNamed:self.porkSwitch.on ? @"HGCreateSwitchView.pork.true" : @"HGCreateSwitchView.pork.false"];
    }];

    [[self.alcoholSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.alcoholImage.image = [UIImage imageNamed:self.alcoholSwitch.on ? @"HGCreateSwitchView.alcohol.true" : @"HGCreateSwitchView.alcohol.false"];
    }];


    [[self.halalSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.halalImage.image = [UIImage imageNamed:self.halalSwitch.on ? @"HGCreateSwitchView.non.halal.true" : @"HGCreateSwitchView.non.halal.false"];
    }];


}

- (void)updateConstraints {

    self.translatesAutoresizingMaskIntoConstraints = false;

    [self.halalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.width.equalTo(@(31));
        make.height.equalTo(@31);
        make.centerY.equalTo(self.halalSwitch.mas_centerY);
    }];

    [self.halalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.halalSwitch.mas_centerY);
        make.left.equalTo(self.halalImage.mas_right).offset(8);
        make.right.equalTo(self.halalSwitch.mas_left).offset(-8);
    }];

    [self.halalSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(@(67));
        make.height.equalTo(@31);
        make.right.equalTo(self).offset(-8);
    }];

    [self.alcoholImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.width.equalTo(@(31));
        make.height.equalTo(@31);
        make.centerY.equalTo(self.alcoholSwitch.mas_centerY);
    }];

    [self.alcoholLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alcoholSwitch.mas_centerY);
        make.left.equalTo(self.alcoholImage.mas_right).offset(8);
        make.right.equalTo(self.alcoholSwitch.mas_left).offset(-8);
    }];

    [self.alcoholSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.halalSwitch.mas_bottom).offset(8);
        make.width.equalTo(@(67));
        make.height.equalTo(@31);
        make.right.equalTo(self).offset(-8);
    }];

    [self.porkImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.width.equalTo(@(31));
        make.height.equalTo(@31);
        make.centerY.equalTo(self.porkSwitch.mas_centerY);
    }];

    [self.porkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.porkSwitch.mas_centerY);
        make.left.equalTo(self.porkImage.mas_right).offset(8);
        make.right.equalTo(self.porkSwitch.mas_left).offset(-8);
    }];

    [self.porkSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alcoholSwitch.mas_bottom).offset(8);
        make.width.equalTo(@(67));
        make.height.equalTo(@31);
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self);
    }];

    [super updateConstraints];
}
@end
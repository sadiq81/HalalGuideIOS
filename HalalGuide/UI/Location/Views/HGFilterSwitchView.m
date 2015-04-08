//
// Created by Privat on 31/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGFilterSwitchView.h"

@interface HGFilterSwitchView ()

@property(strong, nonatomic) SevenSwitch *halalSwitch;
@property(strong, nonatomic) UILabel *halalLabel;

@property(strong, nonatomic) SevenSwitch *alcoholSwitch;
@property(strong, nonatomic) UILabel *alcoholLabel;

@property(strong, nonatomic) SevenSwitch *porkSwitch;
@property(strong, nonatomic) UILabel *porkLabel;

@property(strong, nonatomic) HGLocationViewModel *viewModel;

@end

@implementation HGFilterSwitchView {

}

- (id)initWithViewModel:(HGLocationViewModel *)model {
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

    self.halalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.halalLabel.text = NSLocalizedString(@"HGFilterSwitchView.label.halal", nil);
    self.halalLabel.adjustsFontSizeToFitWidth = true;
    self.halalLabel.minimumScaleFactor = 0.5;
    [self addSubview:self.halalLabel];

    self.halalSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    self.halalSwitch.onLabel.text = NSLocalizedString(@"HGFilterSwitchView.switch.on", nil);
    self.halalSwitch.offLabel.text = NSLocalizedString(@"HGFilterSwitchView.switch.off", nil);
    self.halalSwitch.onTintColor = [UIColor redColor];
    self.halalSwitch.inactiveColor = [UIColor greenColor];
    self.halalSwitch.on = self.viewModel.showNonHalal.boolValue;
    [self addSubview:self.halalSwitch];

    self.alcoholLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.alcoholLabel.text = NSLocalizedString(@"HGFilterSwitchView.label.alcohol", nil);
    self.alcoholLabel.adjustsFontSizeToFitWidth = true;
    self.alcoholLabel.minimumScaleFactor = 0.5;
    [self addSubview:self.alcoholLabel];

    self.alcoholSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    self.alcoholSwitch.onLabel.text = NSLocalizedString(@"HGFilterSwitchView.switch.on", nil);
    self.alcoholSwitch.offLabel.text = NSLocalizedString(@"HGFilterSwitchView.switch.off", nil);
    self.alcoholSwitch.onTintColor = [UIColor redColor];
    self.alcoholSwitch.inactiveColor = [UIColor greenColor];
    self.alcoholSwitch.on = self.viewModel.showAlcohol.boolValue;
    [self addSubview:self.alcoholSwitch];

    self.porkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.porkLabel.text = NSLocalizedString(@"HGFilterSwitchView.label.pork", nil);
    self.porkLabel.adjustsFontSizeToFitWidth = true;
    self.porkLabel.minimumScaleFactor = 0.5;
    [self addSubview:self.porkLabel];

    self.porkSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    self.porkSwitch.onLabel.text = NSLocalizedString(@"HGFilterSwitchView.switch.on", nil);
    self.porkSwitch.offLabel.text = NSLocalizedString(@"HGFilterSwitchView.switch.off", nil);
    self.porkSwitch.onTintColor = [UIColor redColor];
    self.porkSwitch.inactiveColor = [UIColor greenColor];
    self.porkSwitch.on = self.viewModel.showPork.boolValue;
    [self addSubview:self.porkSwitch];

}

- (void)setupViewModel {

    //TODO is this MVVM?
    RAC(self.viewModel, showNonHalal) = [RACObserve(self, halalSwitch.on) skip:1];
    RAC(self.viewModel, showAlcohol) = [RACObserve(self, alcoholSwitch.on) skip:1];
    RAC(self.viewModel, showPork) = [RACObserve(self, porkSwitch.on) skip:1];

}

- (void)updateConstraints {

    self.translatesAutoresizingMaskIntoConstraints = false;

    [self.halalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.halalSwitch.mas_centerY);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self.halalSwitch.mas_left).offset(-8);
    }];

    [self.halalSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(@(67));
        make.height.equalTo(@31);
        make.right.equalTo(self).offset(-8);
    }];

    [self.alcoholLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alcoholSwitch.mas_centerY);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self.alcoholSwitch.mas_left).offset(-8);
    }];

    [self.alcoholSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.halalSwitch.mas_bottom).offset(8);
        make.width.equalTo(@(67));
        make.height.equalTo(@31);
        make.right.equalTo(self).offset(-8);
    }];

    [self.porkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.porkSwitch.mas_centerY);
        make.left.equalTo(self).offset(8);
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
//
// Created by Privat on 11/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGLocationDetailsSubmitterView.h"
#import "HGLabels.h"
#import "ReactiveCocoa.h"

@interface HGLocationDetailsSubmitterView ()

@property(strong) UILabel *submitterHeadLine;
@property(strong) UILabel *submitterName;
@property(strong) UIImageView *submitterImage;


@end

@implementation HGLocationDetailsSubmitterView {

}
- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [self setupViews];
        [self setupViewModel];

    }

    return self;
}

+ (instancetype)viewWithViewModel:(LocationDetailViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {
    self.submitterImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.submitterImage];

    self.submitterHeadLine = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    self.submitterHeadLine.text = NSLocalizedString(@"LocationDetailViewController.label.submitterHeadLine", nil);
    [self addSubview:self.submitterHeadLine];

    self.submitterName = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:17];
    [self addSubview:self.submitterName];
}

- (void)setupViewModel {
    RAC(self.submitterImage, image) = RACObserve(self, viewModel.submitterImage);
    RAC(self.submitterName, text) = RACObserve(self, viewModel.submitterName);
}

- (void)updateConstraints {

    self.translatesAutoresizingMaskIntoConstraints = false;

    [self.submitterImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];

    [self.submitterHeadLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
        make.right.equalTo(self).offset(-8);
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self.submitterImage.mas_bottom);
    }];

    [super updateConstraints];
}

@end
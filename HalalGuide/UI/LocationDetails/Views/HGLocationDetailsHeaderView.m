//
// Created by Privat on 29/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGLocationDetailsHeaderView.h"
#import "Masonry/Masonry.h"

@interface HGLocationDetailsHeaderView ()
@property(strong, nonatomic) HGLocationDetailsInfoView *headerTopView;
@property(strong, nonatomic) HGLocationDetailsSubmitterView *submitterView;
@property(strong, nonatomic) HGLocationDetailsPictureView *pictureView;
@end

@implementation HGLocationDetailsHeaderView {

}

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
    }

    return self;
}

+ (instancetype)viewWithViewModel:(LocationDetailViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {

    self.headerTopView = [HGLocationDetailsInfoView viewWithViewModel:self.viewModel];
    [self addSubview:self.headerTopView];

    self.submitterView = [HGLocationDetailsSubmitterView viewWithViewModel:self.viewModel];
    [self addSubview:self.submitterView];

    self.pictureView = [HGLocationDetailsPictureView viewWithViewModel:self.viewModel];
    [self addSubview:self.pictureView];
}

- (void)updateConstraints {

    [self.headerTopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(120));
        make.bottom.equalTo(self.submitterView.mas_top);
    }];

    [self.submitterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTopView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(48));
        make.bottom.equalTo(self.pictureView.mas_top);
    }];

    [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(260));
        make.bottom.equalTo(self);
    }];

    [super updateConstraints];
}


@end
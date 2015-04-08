//
// Created by Privat on 31/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGCategoriesView.h"

@interface HGCategoriesView ()

@property(strong, nonatomic) UIButton *choose;
@property(strong, nonatomic) UIButton *reset;

@property(strong, nonatomic) UILabel *categories;
@property(strong, nonatomic) UILabel *countLabel;

@property(strong, nonatomic) id <CategoriesViewModel> viewModel;
@end

@implementation HGCategoriesView {

}

- (id)initWithViewModel:(id <CategoriesViewModel>)model {
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

    self.categories = [[UILabel alloc] initWithFrame:CGRectZero];
    self.categories.text = NSLocalizedString(@"HGCategoriesView.label.categories", nil);
    [self addSubview:self.categories];

    self.countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    [self setCountLabelText];
    [self addSubview:self.countLabel];

    self.reset = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reset setTitle:NSLocalizedString(@"HGCategoriesView.button.reset", nil) forState:UIControlStateNormal];
    self.reset.hidden = self.viewModel.locationType == LocationTypeMosque;
    [self addSubview:self.reset];

    self.choose = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.choose setTitle:NSLocalizedString(@"HGCategoriesView.button.chose", nil) forState:UIControlStateNormal];
    [self addSubview:self.choose];
}

- (void)setupViewModel {
    @weakify(self)
    [[self.reset rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        switch (self.viewModel.locationType) {
            case LocationTypeDining: {
                [self.viewModel.categories removeAllObjects];
                break;
            }
            case LocationTypeShop: {
                [self.viewModel.shopCategories removeAllObjects];
                break;
            }
            case LocationTypeMosque: {
                break;
            }
        }
        [self setCountLabelText];
    }];
}

- (void)setCountLabelText {

    if (self.viewModel.locationType == LocationTypeMosque) {
        self.countLabel.text = NSLocalizedString(LanguageString(self.viewModel.language), nil);
    } else if (self.viewModel.locationType == LocationTypeShop) {
        self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) [self.viewModel.shopCategories count]];
    } else if (self.viewModel.locationType == LocationTypeDining) {
        self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) [self.viewModel.categories count]];
    }
}


- (void)updateConstraints {

    self.translatesAutoresizingMaskIntoConstraints = false;

    [self.categories mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(8);
        make.bottom.equalTo(self);
    }];

    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.categories.mas_right).offset(8);
        make.bottom.equalTo(self);
    }];

    [self.reset mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.choose.mas_left).offset(-8);
        make.bottom.equalTo(self);
    }];

    [self.choose mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self);
    }];

    [super updateConstraints];
}


@end
//
// Created by Privat on 31/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LocationViewModel.h"


@interface HGCategoriesView : UIView

@property(strong, nonatomic, readonly) UIButton *choose;
@property(strong, nonatomic, readonly) UIButton *reset;

@property(strong, nonatomic, readonly) UILabel *categories;
@property(strong, nonatomic, readonly) UILabel *countLabel;

@property(strong, nonatomic, readonly) LocationViewModel *viewModel;

- (id)initWithViewModel:(LocationViewModel *)model;

- (void)setCountLabelText;
@end
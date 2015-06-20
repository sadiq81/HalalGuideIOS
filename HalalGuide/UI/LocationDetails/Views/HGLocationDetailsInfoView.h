//
// Created by Privat on 09/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGLocationDetailViewModel.h"
#import "EDStarRating/EDStarRating.h"


@interface HGLocationDetailsInfoView : UIView

@property(strong, readonly) UILabel *name;
@property(strong, readonly) UILabel *road;
@property(strong, readonly) UILabel *postalCode;
@property(strong, readonly) UILabel *distance;
@property(strong, readonly) UILabel *km;
@property(strong, readonly) EDStarRating *rating;
@property(strong, readonly) UILabel *category;
@property(strong, readonly) UIImageView *porkImage;
@property(strong, readonly) UIImageView *alcoholImage;
@property(strong, readonly) UIImageView *halalImage;
@property(strong, readonly) UIImageView *languageImage;
@property(strong, readonly) UILabel *languageLabel;

@property(strong, readonly, nonatomic) HGLocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel;

+ (instancetype)viewWithViewModel:(HGLocationDetailViewModel *)viewModel;


@end
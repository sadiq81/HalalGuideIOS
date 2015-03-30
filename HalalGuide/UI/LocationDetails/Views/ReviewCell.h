//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Review.h"
#import "EDStarRating.h"

@class ReviewDetailViewModel;

@interface ReviewCell : UITableViewCell

@property(strong, nonatomic, readonly) UIImageView *submitterImage;
@property(strong, nonatomic, readonly) UILabel *submitterName;
@property(strong, nonatomic, readonly) EDStarRating *rating;
@property(strong, nonatomic, readonly) UILabel *review;
@property(strong, nonatomic) ReviewDetailViewModel *viewModel;

@end
//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncImageView/AsyncImageView.h>
#import "HGReview.h"
#import "EDStarRating.h"

@class HGReviewDetailViewModel;

@interface HGReviewCell : UITableViewCell

@property(strong, nonatomic, readonly) AsyncImageView *submitterImage;
@property(strong, nonatomic, readonly) UILabel *submitterName;
@property(strong, nonatomic, readonly) EDStarRating *rating;
@property(strong, nonatomic, readonly) UILabel *review;

@property(strong, nonatomic, readonly) AsyncImageView *image1;
@property(strong, nonatomic, readonly) AsyncImageView *image2;
@property(strong, nonatomic, readonly) AsyncImageView *image3;

@property(strong, nonatomic) HGReviewDetailViewModel *viewModel;

@end
//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EDStarRating.h>
#import "HGReview.h"
#import <ParseUI/ParseUI.h>

@class HGReviewDetailViewModel;

@interface HGReviewDetailViewController : UIViewController {
}

@property(strong, nonatomic, readonly) UIImageView *submitterImage;
@property(strong, nonatomic, readonly) UILabel *submitterName;
@property(strong, nonatomic, readonly) EDStarRating *rating;
@property(strong, nonatomic, readonly) UITextView *review;
@property(strong, nonatomic, readonly) UILabel *date;

@property(strong, nonatomic, readonly) HGReviewDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(HGReviewDetailViewModel *)model;

+ (instancetype)controllerWithViewModel:(HGReviewDetailViewModel *)model;


@end
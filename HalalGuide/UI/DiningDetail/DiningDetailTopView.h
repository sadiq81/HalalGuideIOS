//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//
#define kNameTag 100
#define kAddressTag 101
#define kDistanceTag 103
#define kRatingTag 400
#define kCategoryTag 102
#define kPorkImageTag 200
#define kAlcoholImageTag 201
#define kHalalImageTag 202
#define kPorkLabelTag 104
#define kAlcoholLabelTag 105
#define kHalalLabelTag 106
#define kReportTag 300
#define kAddReviewTag 301
#define kAddPictureTag 302
#define kCarouselTag 401
#define kContainerViewTag 1

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "HalalGuideImageViews.h"
#import "HalalGuideLabels.h"
#import "iCarousel.h"
#import "DiningDetailViewModel.h"
#import <MessageUI/MessageUI.h>

@interface DiningDetailTopView : UICollectionReusableView {

}

@property(strong) IBOutlet UILabel *name;
@property(strong) IBOutlet UILabel *address;
@property(strong) IBOutlet UILabel *distance;
@property(strong) IBOutlet EDStarRating *rating;
@property(strong) IBOutlet UILabel *category;
@property(strong) IBOutlet PorkImageView *porkImage;
@property(strong) IBOutlet AlcoholImageView *alcoholImage;
@property(strong) IBOutlet HalalImageView *halalImage;
@property(strong) IBOutlet PorkLabel *porkLabel;
@property(strong) IBOutlet AlcoholLabel *alcoholLabel;
@property(strong) IBOutlet HalalLabel *halalLabel;
@property(strong) IBOutlet UIButton *report;
@property(strong) IBOutlet UIButton *addReview;
@property(strong) IBOutlet UIButton *addPicture;
@property(strong) IBOutlet iCarousel *carousel;
@property(strong) IBOutlet UIView *containerView;

@end
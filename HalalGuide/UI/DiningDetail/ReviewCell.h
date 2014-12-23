//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//
#define kReviewCellIdentifer @"ReviewCell"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class EDStarRating;
@class Review;


@interface ReviewCell : UICollectionViewCell

@property (strong) IBOutlet UIImageView *profileImage;
@property (strong) IBOutlet UILabel *submitterName;
@property (strong) IBOutlet EDStarRating *rating;
@property (strong) IBOutlet UILabel *review;

-(void) configure:(Review *)review1;

@end
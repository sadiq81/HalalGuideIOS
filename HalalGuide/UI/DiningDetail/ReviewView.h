//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EDStarRating.h"

#define kReviewerImageTag 100
#define kReviewerNameLabelTag 200
#define kReviewTextTag 201
#define kReviewRatingTag 300

@interface ReviewView : UIView{
    
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet EDStarRating *rating;
@property (strong, nonatomic) IBOutlet UILabel *review;


@end
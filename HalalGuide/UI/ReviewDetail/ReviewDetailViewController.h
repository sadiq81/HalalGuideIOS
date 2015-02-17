//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EDStarRating.h>
#import "Review.h"
#import <ParseUI/ParseUI.h>

@class ReviewDetailViewModel;

@interface ReviewDetailViewController : UIViewController {
}

@property(strong, nonatomic) IBOutlet PFImageView *profilePicture;
@property(strong, nonatomic) IBOutlet UILabel *name;
@property(strong, nonatomic) IBOutlet UILabel *date;
@property(strong, nonatomic) IBOutlet EDStarRating *rating;
@property(strong, nonatomic) IBOutlet UITextView *reviewText;

@property(strong, nonatomic) ReviewDetailViewModel *viewModel;

@end
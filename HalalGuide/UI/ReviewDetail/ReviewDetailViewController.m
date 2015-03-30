//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "LocationDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImageView+WebCache.h"
#import "HalalGuideDateFormatter.h"
#import "PFUser+Extension.h"

@interface ReviewDetailViewController ()
@property(strong, nonatomic) UIImageView *submitterImage;
@property(strong, nonatomic) UILabel *submitterName;
@property(strong, nonatomic) EDStarRating *rating;
@property(strong, nonatomic) UITextView *review;
@property(strong, nonatomic) UILabel *date;

@end


@implementation ReviewDetailViewController {

}

- (void)viewDidLoad {
    [self setupRating];
    [self setupViewModel];
}
- (void)setupRating {

    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
}

- (void)setupViewModel {

    RAC(self.submitterName, text) = RACObserve(self, viewModel.submitterName);
    RAC(self.submitterImage, image) = RACObserve(self, viewModel.submitterImage);

    RAC(self.review, text) = RACObserve(self, viewModel.reviewText);
    RAC(self.rating, rating) = RACObserve(self, viewModel.rating);
}



@end
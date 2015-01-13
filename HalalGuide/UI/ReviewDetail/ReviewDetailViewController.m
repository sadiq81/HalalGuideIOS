//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "PictureService.h"
#import "LocationDetailViewModel.h"
#import "ReviewDetailViewModel.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "NSObject+RACPropertySubscribing.h"
#import "RACSignal.h"
#import "ProfileInfo.h"
#import "UIImageView+WebCache.h"
#import "HalalGuideDateFormatter.h"
#import "PFUser+Extension.h"


@implementation ReviewDetailViewController {

}

- (void)viewDidLoad {
    [self setupUIValues];
}

- (void)setupUIValues {

    [[PFUser query] getObjectInBackgroundWithId:[ReviewDetailViewModel instance].review.submitterId block:^(PFObject *object, NSError *error) {
        PFUser *user = (PFUser *) object;
        self.name.text = user.facebookName;
        [self.profilePicture sd_setImageWithURL:user.facebookProfileUrl];
    }];

    //TODO add category to NSDate
    self.date.text = [[HalalGuideDateFormatter instance] stringFromDate:[ReviewDetailViewModel instance].review.createdAt];
    self.reviewText.text = [ReviewDetailViewModel instance].review.review;

    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
    self.rating.rating = [[ReviewDetailViewModel instance].review.rating floatValue];
}

@end
//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGReviewDetailViewModel.h"
#import "HGPictureService.h"
#import "HGDateFormatter.h"
#import "HGErrorReporting.h"
#import "HGLocationPicture.h"
#import "HGUser.h"
#import "HGUserService.h"
#import "ReactiveCocoa.h"

@interface HGReviewDetailViewModel () {
}
@property(nonatomic) HGReview *review;
@property(strong, nonatomic) NSURL *submitterImage;
@property(strong, nonatomic) NSURL *submitterImageLarge;
@property(strong, nonatomic) NSString *submitterName;
@property(strong, nonatomic) NSNumber *rating;
@property(strong, nonatomic) NSString *reviewText;
@property(strong, nonatomic) NSString *date;

@property(strong, nonatomic) NSArray *reviewImages;


@end

@implementation HGReviewDetailViewModel {

}

- (instancetype)initWithReview:(HGReview *)review {
    self = [super init];
    if (self) {
        _review = review;
        [self setup];
    }

    return self;
}

+ (instancetype)modelWithReview:(HGReview *)review {
    return [[self alloc] initWithReview:review];
}

- (void)setup {

    self.rating = self.review.rating;
    self.reviewText = self.review.review;
    self.date = [HGDateFormatter shortDateFormat:self.review.createdAt];

    @weakify(self)
    [[HGUserService instance] getUserInBackGround:self.review.submitterId onCompletion:^(PFObject *object, NSError *error) {
        @strongify(self)
        HGUser *user = (HGUser *) object;
        self.submitterImage = [user facebookProfileUrlSmall];
        self.submitterImageLarge = [user facebookProfileUrl];
        self.submitterName = [user facebookName];
    }];


    [[HGPictureService instance] locationPicturesForReview:self.review onCompletion:^(NSArray *pictures, NSError *error) {
        @strongify(self)
        self.reviewImages = pictures;
    }];

}


@end
//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGCreateReviewViewModel.h"
#import "HGReview.h"
#import "HGReviewService.h"
#import "HGErrorReporting.h"

@interface HGCreateReviewViewModel ()

@property (nonatomic, strong) HGLocation *location;
@property (nonatomic, strong) HGReview *createdReview;

@end

@implementation HGCreateReviewViewModel {

}

- (instancetype)initWithReviewedLocation:(HGLocation *)reviewedLocation {
    self = [super init];
    if (self) {
        self.location = reviewedLocation;
    }

    return self;
}

+ (instancetype)modelWithReviewedLocation:(HGLocation *)reviewedLocation {
    return [[self alloc] initWithReviewedLocation:reviewedLocation];
}

- (void)saveReview{

    HGReview *review = [HGReview object];
    review.review = self.reviewText;
    review.rating = self.rating;
    review.submitterId = [PFUser currentUser].objectId;
    review.locationId = self.location.objectId;
    review.creationStatus = @(CreationStatusAwaitingApproval);

    self.saving = true;
    [[HGReviewService instance] saveReview:review onCompletion:^(BOOL succeeded, NSError *error) {
        self.saving = false;
        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.createdReview = review;
        }
    }];
}


@end
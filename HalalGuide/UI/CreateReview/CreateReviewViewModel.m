//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateReviewViewModel.h"
#import "Review.h"
#import "HGReviewService.h"
#import "HGErrorReporting.h"


@implementation CreateReviewViewModel {

}

@synthesize location, createdReview;

- (instancetype)initWithReviewedLocation:(Location *)reviewedLocation {
    self = [super init];
    if (self) {
        self.location = reviewedLocation;
    }

    return self;
}

+ (instancetype)modelWithReviewedLocation:(Location *)reviewedLocation {
    return [[self alloc] initWithReviewedLocation:reviewedLocation];
}

- (void)saveEntity:(NSString *)reviewText rating:(int)rating {

    Review *review = [Review object];
    review.review = reviewText;
    review.rating = @(rating);
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
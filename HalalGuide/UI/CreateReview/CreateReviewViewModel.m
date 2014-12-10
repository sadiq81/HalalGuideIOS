//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateReviewViewModel.h"
#import "LocationService.h"
#import "Review.h"
#import "ReviewService.h"
#import "KeyChainService.h"
#import "ErrorReporting.h"


@implementation CreateReviewViewModel {

}

@synthesize reviewedLocation;

+ (CreateReviewViewModel *)instance {
    static CreateReviewViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];

        }
    }

    return _instance;
}

- (void)saveEntity:(NSString *)reviewText rating:(int)rating onCompletion:(void (^)(CreateEntityResult result))completion {

    Review *review = [Review object];
    review.review = reviewText;
    review.rating = @(rating);
    review.submitterId  = [PFUser currentUser].objectId;
    review.locationId = self.reviewedLocation.objectId;
    review.creationStatus = @(CreationStatusAwaitingApproval);

    [[ReviewService instance] saveReview:review onCompletion:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[ErrorReporting instance] reportError:error];
            completion(CreateEntityResultCouldNotCreateEntityInDatabase);
        } else {
            completion(CreateEntityResultOk);
        }
    }];
}


@end
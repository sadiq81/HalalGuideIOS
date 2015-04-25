//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGCreateReviewViewModel.h"
#import "HGReview.h"
#import "HGReviewService.h"
#import "HGErrorReporting.h"
#import "HGPictureService.h"

@interface HGCreateReviewViewModel ()

@property (nonatomic, strong) HGLocation *location;

@end

@implementation HGCreateReviewViewModel {

}

- (instancetype)initWithReviewedLocation:(HGLocation *)reviewedLocation {
    self = [super init];
    if (self) {
        self.location = reviewedLocation;
        self.images = [NSArray new];
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

    self.progress = 1;

    [[[[self saveReview:review] then:^RACSignal * {
        return ([self.images count] > 0) ? [self saveImagesForReview:review] :[RACSignal empty];
    }] finally:^{
        self.progress = 100;
    }] subscribeError:^(NSError *error) {
        self.error = error;
        [review deleteEventually];
    }];

}

- (RACSignal *)saveReview:(HGReview *)review {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[HGReviewService instance] saveReview:review onCompletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [subscriber sendNext:@(succeeded)];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)saveImagesForReview:(HGReview *)review {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[HGPictureService instance] saveMultiplePictures:self.images forReview:review completion:^(BOOL completed, NSError *error, NSNumber *progress) {
            if (progress) {
                self.progress = progress.intValue;
                [subscriber sendNext:progress];
            }
            if (completed) {
                [subscriber sendCompleted];
            }
            if (error) {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}


@end
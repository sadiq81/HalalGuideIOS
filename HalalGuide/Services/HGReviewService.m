//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGReviewService.h"
#import "HGLocation.h"

@implementation HGReviewService {

}

+ (HGReviewService *)instance {
    static HGReviewService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)saveReview:(HGReview *)review onCompletion:(PFBooleanResultBlock)completion {
    [review saveInBackgroundWithBlock:completion];
}

- (void)reviewsForLocation:(HGLocation *)location onCompletion:(PFArrayResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:kReviewTableName];
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query whereKey:@"locationId" equalTo:location.objectId];
    [query findObjectsInBackgroundWithBlock:completion];
}

@end
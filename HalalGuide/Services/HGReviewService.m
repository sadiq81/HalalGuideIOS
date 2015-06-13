//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "HGReviewService.h"
#import "HGLocation.h"
#import "HGQuery.h"


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

- (void)reviewById:(NSString *)objectId onCompletion:(PFIdResultBlock)completion {
    [[HGReview query] getObjectInBackgroundWithId:objectId block:completion];
}

- (void)saveReview:(HGReview *)review onCompletion:(PFBooleanResultBlock)completion {
    //TODO Offline handling
    [review saveInBackgroundWithBlock:completion];
}

- (void)reviewsForLocation:(HGLocation *)location onCompletion:(PFArrayResultBlock)completion {

    HGQuery *query = [HGQuery queryWithClassName:kReviewTableName];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query whereKey:@"locationId" equalTo:location.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects withName:@"reviewsForLocation"];
        }
        completion(objects, error);
    }];

}

@end
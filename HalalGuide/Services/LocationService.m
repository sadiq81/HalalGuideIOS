//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "LocationService.h"
#import "HalalGuideSettings.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation LocationService {

}

+ (LocationService *)instance {
    static LocationService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)saveLocation:(Location *)location onCompletion:(PFBooleanResultBlock)completion {
    [location saveInBackgroundWithBlock:completion];
}

- (void)locationsByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion {
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)lastTenLocations:(PFArrayResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:kLocationTableName];
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query orderByDescending:@"updatedAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:completion];
}

@end
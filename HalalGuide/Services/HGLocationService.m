//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "HGLocationService.h"
#import "HGQuery.h"


@implementation HGLocationService {

}

+ (HGLocationService *)instance {
    static HGLocationService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

//TODO Offline handling
- (void)saveLocation:(HGLocation *)location onCompletion:(PFBooleanResultBlock)completion {
    [location saveInBackgroundWithBlock:completion];
}

- (void)locationsByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion {
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects];
        }
        completion(objects, error);
    }];
}

- (void)lastTenLocations:(PFArrayResultBlock)completion {

    HGQuery *query = [HGQuery queryWithClassName:kLocationTableName];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query orderByDescending:@"updatedAt"];
    query.limit = 10;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects];
        }
        completion(objects, error);
    }];


}

@end
//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "HGLocationService.h"
#import "HGQuery.h"
#import "HGChangeSuggestion.h"


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

- (void)locationById:(NSString *)objectId onCompletion:(PFIdResultBlock)completion {
    [[HGLocation query] getObjectInBackgroundWithId:objectId block:completion];
}

//TODO Offline handling
- (void)saveLocation:(HGLocation *)location onCompletion:(PFBooleanResultBlock)completion {
    [location saveInBackgroundWithBlock:completion];
}

//TODO Offline handling
- (void)saveSuggestion:(HGChangeSuggestion *)suggestion onCompletion:(void (^)(BOOL, NSError *))completion {
    [suggestion saveInBackgroundWithBlock:completion];
}

- (void)locationsByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion {

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects withName:@"locationsByQuery"];
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
            [PFObject pinAllInBackground:objects withName:@"lastTenLocations"];
        }
        completion(objects, error);
    }];


}


- (void)findExistingLocationsWithName:(NSString *)name onCompletion:(PFArrayResultBlock)completion {
    HGQuery *query = [HGQuery queryWithClassName:kLocationTableName];
    [query whereKey:@"name" equalTo:name];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects withName:@"findExistingLocationsWithName"];
        }
        completion(objects, error);
    }];


}
@end
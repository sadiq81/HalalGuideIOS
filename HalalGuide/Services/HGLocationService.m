//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "HGLocationService.h"


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
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [query fromLocalDatastore];
    }
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)lastTenLocations:(PFArrayResultBlock)completion {


/*    PFQuery *query = [PFQuery queryWithClassName:kLocationTableName];

    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [query fromLocalDatastore];
    }

    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query orderByDescending:@"updatedAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:completion];*/

    HGLocation *location = [HGLocation object];
    location.addressCity = @"København N";
    location.addressPostalCode = @"2200";
    location.addressRoad = @"Jagvej";
    location.addressRoadNumber = @"32";
    location.alcohol = @0;
    location.creationStatus = @1;
    location.point = [PFGeoPoint geoPointWithLatitude:52.0000 longitude:11.0000];
    location.locationType = @0;
    location.name = @"Mamma Mia";
    location.nonHalal = @0;
    location.pork = @0;
    location.submitterId = @"123456";
    location.telephone = @"+4512345678";

    completion(@[location], nil);

}

@end
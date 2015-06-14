//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//


#import "HGLocationService.h"
#import "HGCategoryViewModel.h"
#import "MapKit/MapKit.h"
#import "NSMutableString+Extensions.h"
#import "HGErrorReporting.h"
#import "HGSettings.h"
#import "HGLocationDetailViewModel.h"
#import "HGGeoLocationService.h"
#import "HGQuery.h"

@interface HGCategoryViewModel () {
}
@property(nonatomic, copy) NSArray *locations;
@property(nonatomic) LocationType locationType;

@end

@implementation HGCategoryViewModel {

}
@synthesize southWest, northEast, locationType, categories, shopCategories, language;

- (instancetype)initWithLocationType:(LocationType)type {
    self = [super init];
    if (self) {
        self.locationType = type;
    }

    return self;
}

+ (instancetype)modelWithLocationType:(LocationType)type {
    return [[self alloc] initWithLocationType:type];
}

- (PFQuery *)query {

    HGQuery *query = [HGQuery queryWithClassName:kLocationTableName];
    [query whereKey:@"locationType" equalTo:@(self.locationType)];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];

    if (self.locationType == LocationTypeDining) {

        if ([self.categories count] > 0) {
            [query whereKey:@"categories" containedIn:self.categories];
        }

    } else if (self.locationType == LocationTypeShop) {

        if ([self.shopCategories count] > 0) {
            [query whereKey:@"categories" containedIn:self.shopCategories];
        }

    } else if (self.locationType == LocationTypeMosque) {

        if (self.language > 0) {
            [query whereKey:@"language" equalTo:@(self.language)];
        }

    }

    CLLocation *location = [HGGeoLocationService instance].currentLocation;

    if (location) {
        [query whereKey:@"point" nearGeoPoint:[PFGeoPoint geoPointWithLocation:location] withinKilometers:20000];
    }

    return query;
}


- (HGLocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index {
    return [HGLocationDetailViewModel modelWithLocation:self.locations[index]];
}


- (void)refreshLocations {

    self.fetchCount++;
    [[HGLocationService instance] locationsByQuery:self.query onCompletion:^(NSArray *objects, NSError *error) {

        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.locations = objects;
        }
    }];
}


@end


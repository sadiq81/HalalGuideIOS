//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//


#import "HGLocationService.h"
#import "LocationViewModel.h"
#import "MapKit/MapKit.h"
#import "NSMutableString+Extensions.h"
#import "HGErrorReporting.h"
#import "HGSettings.h"
#import "LocationDetailViewModel.h"

@interface LocationViewModel () {
}

@property(nonatomic) NSArray *listLocations;
@property(nonatomic) NSArray *mapLocations;
@end

@implementation LocationViewModel {

}


@synthesize mapLocations, listLocations, locationType, maximumDistance, showNonHalal, showAlcohol, showPork, categories, shopCategories, language, page, searchText, locationPresentation, southWest, northEast;

- (instancetype)initWithLocationType:(LocationType)aLocationType {
    self = [super init];
    if (self) {
        self.locationType = aLocationType;

        maximumDistance = (int) [HGSettings instance].distanceFilter;
        showPork = [HGSettings instance].porkFilter;
        showAlcohol = [HGSettings instance].alcoholFilter;
        showNonHalal = [HGSettings instance].halalFilter;
        categories = [HGSettings instance].categoriesFilter;
        shopCategories = [HGSettings instance].shopCategoriesFilter;
        mapLocations = [NSArray new];
        listLocations = [NSArray new];
        page = 0;

        [self configureLocation];

        [self refreshLocations];
    }

    return self;
}

+ (instancetype)modelWithLocationType:(LocationType)locationType {
    return [[self alloc] initWithLocationType:locationType];
}

- (void)configureLocation {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"locationManager:didUpdateLocations" object:nil] subscribeNext:^(NSNotification *notification) {
        self.userLocation = [notification.userInfo objectForKey:@"lastObject"];
    }];
}

- (PFQuery *)query {

    PFQuery *query = [PFQuery queryWithClassName:kLocationTableName];
    [query whereKey:@"locationType" equalTo:@(self.locationType)];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];

    if (self.locationPresentation == LocationPresentationList) {


        if (self.locationType == LocationTypeDining) {

            if (!self.showPork) {
                [query whereKey:@"pork" equalTo:@(self.showPork)];
            }

            if (!self.showAlcohol) {
                [query whereKey:@"alcohol" equalTo:@(self.showAlcohol)];
            }

            if (!self.showNonHalal) {
                [query whereKey:@"nonHalal" equalTo:@(self.showNonHalal)];
            }

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

        if (self.searchText && [self.searchText length] > 0) {

            PFQuery *name = [PFQuery orQueryWithSubqueries:@[query]];
            [name whereKey:@"name" matchesRegex:self.searchText modifiers:@"i"];

            PFQuery *addressCity = [PFQuery orQueryWithSubqueries:@[query]];
            [addressCity whereKey:@"addressCity" matchesRegex:self.searchText modifiers:@"i"];

            PFQuery *addressPostalCode = [PFQuery orQueryWithSubqueries:@[query]];
            [addressPostalCode whereKey:@"addressPostalCode" matchesRegex:self.searchText modifiers:@"i"];

            PFQuery *addressRoad = [PFQuery orQueryWithSubqueries:@[query]];
            [addressRoad whereKey:@"addressRoad" matchesRegex:self.searchText modifiers:@"i"];

            PFQuery *addressRoadNumber = [PFQuery orQueryWithSubqueries:@[query]];
            [addressRoadNumber whereKey:@"addressRoadNumber" matchesRegex:self.searchText modifiers:@"i"];

            PFQuery *homePage = [PFQuery orQueryWithSubqueries:@[query]];
            [homePage whereKey:@"homePage" matchesRegex:self.searchText modifiers:@"i"];

            PFQuery *telephone = [PFQuery orQueryWithSubqueries:@[query]];
            [telephone whereKey:@"telephone" matchesRegex:self.searchText modifiers:@"i"];

            PFQuery *or = [PFQuery orQueryWithSubqueries:@[name, addressCity, addressPostalCode, addressRoad, addressRoadNumber, homePage, telephone]];
            //Or queries do not support geo location and limit/skip
            listLocations = [NSArray new];
            return or;
        }

        if (self.userLocation) {
            [query whereKey:@"point" nearGeoPoint:[PFGeoPoint geoPointWithLocation:self.userLocation] withinKilometers:self.maximumDistance < 20 ? self.maximumDistance : 20000]; //TODO
        }

        //Paging controls
        query.limit = 20;
        query.skip = self.page * 20;
    } else if (self.locationPresentation == LocationPresentationMap) {
        [query whereKey:@"point" withinGeoBoxFromSouthwest:self.southWest toNortheast:self.northEast];
    }

    return query;
}


- (LocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index {
    return [LocationDetailViewModel modelWithLocation:self.locationPresentation == LocationPresentationList ? [self.listLocations objectAtIndex:index] : [self.mapLocations objectAtIndex:index]];
}


- (void)refreshLocations {

    self.fetchCount++;
    [[HGLocationService instance] locationsByQuery:self.query onCompletion:^(NSArray *objects, NSError *error) {

        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else if (self.locationPresentation == LocationPresentationList) {
            self.listLocations = (self.page == 0) ? objects : [self.listLocations arrayByAddingObjectsFromArray:objects];
        } else if (self.locationPresentation == LocationPresentationMap) {
            self.mapLocations = (self.page == 0) ? objects : [self.mapLocations arrayByAddingObjectsFromArray:objects];
        }
    }];
}

- (void)setLocationType:(LocationType)locationType1 {
    mapLocations = [NSArray new];
    listLocations = [NSArray new];
    page = 0;
    locationType = locationType1;
}

- (void)setSearchText:(NSString *)searchText1 {
    searchText = searchText1;
    listLocations = [NSArray new];
    page = 0;
    [self refreshLocations];
}

@end


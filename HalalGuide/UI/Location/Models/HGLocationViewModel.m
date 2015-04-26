//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//


#import "HGLocationService.h"
#import "HGLocationViewModel.h"
#import "MapKit/MapKit.h"
#import "NSMutableString+Extensions.h"
#import "HGErrorReporting.h"
#import "HGSettings.h"
#import "HGLocationDetailViewModel.h"
#import "HGGeoLocationService.h"

@interface HGLocationViewModel () {
}

@property(nonatomic) NSArray *listLocations;
@property(nonatomic) NSArray *mapLocations;
@end

@implementation HGLocationViewModel {

}
@synthesize mapLocations, listLocations, locationType, page, searchText, locationPresentation, southWest, northEast;
@dynamic maximumDistance, showNonHalal, showAlcohol, showPork, categories, shopCategories, language;

- (instancetype)initWithLocationType:(LocationType)type {
    self = [super init];
    if (self) {
        self.locationType = type;

        mapLocations = [NSArray new];
        listLocations = [NSArray new];
        page = 0;

        [self refreshLocations];
    }

    return self;
}

+ (instancetype)modelWithLocationType:(LocationType)type {
    return [[self alloc] initWithLocationType:type];
}

- (PFQuery *)query {

    PFQuery *query = [PFQuery queryWithClassName:kLocationTableName];
    [query whereKey:@"locationType" equalTo:@(self.locationType)];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];

    if (self.locationPresentation == LocationPresentationList) {

        if (self.locationType == LocationTypeDining) {

            if ([self.showPork isEqualToNumber:@(0)]) {
                [query whereKey:@"pork" equalTo:@(self.showPork.boolValue)];
            }

            if ([self.showAlcohol isEqualToNumber:@(0)]) {
                [query whereKey:@"alcohol" equalTo:@(self.showAlcohol.boolValue)];
            }

            if ([self.showNonHalal isEqualToNumber:@(0)]) {
                [query whereKey:@"nonHalal" equalTo:@(self.showNonHalal.boolValue)];
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
        CLLocation *location = [HGGeoLocationService instance].currentLocation;

        if (location) {
            [query whereKey:@"point" nearGeoPoint:[PFGeoPoint geoPointWithLocation:location] withinKilometers:self.maximumDistance.intValue < 20 ? self.maximumDistance.intValue : 20000]; //TODO
        }

        //Paging controls
        query.limit = 20;
        query.skip = self.page * 20;
    } else if (self.locationPresentation == LocationPresentationMap) {
        [query whereKey:@"point" withinGeoBoxFromSouthwest:self.southWest toNortheast:self.northEast];
    }

    return query;
}


- (HGLocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index {
    return [HGLocationDetailViewModel modelWithLocation:self.locationPresentation == LocationPresentationList ? [self.listLocations objectAtIndex:index] : [self.mapLocations objectAtIndex:index]];
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

- (void)setLocationType:(LocationType)type {
    mapLocations = [NSArray new];
    listLocations = [NSArray new];
    page = 0;
    locationType = type;
}

- (void)setSearchText:(NSString *)searchText1 {
    [PFAnalytics trackEvent:@"LocationTextSearch" dimensions:@{@"searchText":searchText1}];
    searchText = searchText1;
    listLocations = [NSArray new];
    listLocations = [NSArray new];
    page = 0;
    [self refreshLocations];
}

- (NSNumber *)maximumDistance {
    switch (self.locationType) {
        case LocationTypeShop:
            return [HGSettings instance].maximumDistanceShop;
        case LocationTypeDining:
            return [HGSettings instance].maximumDistanceDining;
        case LocationTypeMosque:
            return [HGSettings instance].maximumDistanceMosque;
        default:
            return nil;
    }
}

- (void)setMaximumDistance:(NSNumber *)maximumDistance {
    [PFAnalytics trackEvent:@"LocationMaximumDistanceSearch" dimensions:@{@"maximumDistance":maximumDistance.stringValue}];
    [self willChangeValueForKey:@"maximumDistance"];
    switch (self.locationType) {
        case LocationTypeShop:
            [HGSettings instance].maximumDistanceShop = maximumDistance;
        case LocationTypeDining:
            [HGSettings instance].maximumDistanceDining = maximumDistance;
        case LocationTypeMosque:
            [HGSettings instance].maximumDistanceMosque = maximumDistance;
    }
    [self didChangeValueForKey:@"maximumDistance"];
}

- (NSNumber *)showNonHalal {
    return [HGSettings instance].halalFilter;
}

- (void)setShowNonHalal:(NSNumber *)showNonHalal {
    [PFAnalytics trackEvent:@"LocationNonHalalSearch" dimensions:@{@"showNonHalal":showNonHalal.stringValue}];
    [self willChangeValueForKey:@"showNonHalal"];
    [HGSettings instance].halalFilter = showNonHalal;
    [self didChangeValueForKey:@"showNonHalal"];
}

- (NSNumber *)showAlcohol {
    return [HGSettings instance].alcoholFilter;
}

- (void)setShowAlcohol:(NSNumber *)showAlcohol {
    [PFAnalytics trackEvent:@"LocationshowAlcoholSearch" dimensions:@{@"showAlcohol":showAlcohol.stringValue}];
    [self willChangeValueForKey:@"showAlcohol"];
    [HGSettings instance].alcoholFilter = showAlcohol;
    [self didChangeValueForKey:@"showAlcohol"];
}

- (NSNumber *)showPork {
    return [HGSettings instance].porkFilter;
}

- (void)setShowPork:(NSNumber *)showPork {
    [PFAnalytics trackEvent:@"LocationShowPorkSearch" dimensions:@{@"showPork":showPork.stringValue}];
    [self willChangeValueForKey:@"showPork"];
    [HGSettings instance].porkFilter = showPork;
    [self didChangeValueForKey:@"showPork"];
}


- (NSMutableArray *)categories {
    return [HGSettings instance].categoriesFilter;
}

- (void)setCategories:(NSMutableArray *)categories {
    [self willChangeValueForKey:@"categories"];
    [HGSettings instance].categoriesFilter = categories;
    [self didChangeValueForKey:@"categories"];
}

- (NSMutableArray *)shopCategories {
    return [HGSettings instance].shopCategoriesFilter;
}

- (void)setShopCategories:(NSMutableArray *)shopCategories {
    [self willChangeValueForKey:@"shopCategories"];
    [HGSettings instance].shopCategoriesFilter = shopCategories;
    [self didChangeValueForKey:@"shopCategories"];
}

- (Language)language {
    return [HGSettings instance].language;
}

- (void)setLanguage:(Language)language {
    [PFAnalytics trackEvent:@"LocationLanguageSearch" dimensions:@{@"language":@(language).stringValue}];
    [self willChangeValueForKey:@"language"];
    [HGSettings instance].language = language;
    [self didChangeValueForKey:@"language"];
}


@end


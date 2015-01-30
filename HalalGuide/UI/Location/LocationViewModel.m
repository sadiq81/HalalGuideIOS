//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//


#import "LocationService.h"
#import "LocationViewModel.h"
#import "MapKit/MapKit.h"
#import "NSMutableString+Extensions.h"
#import "SVProgressHUD.h"
#import "ErrorReporting.h"
#import "HalalGuideSettings.h"

@implementation LocationViewModel {

}

@synthesize locations, locationType, delegate, maximumDistance, showNonHalal, showAlcohol, showPork, categories, shopCategories, language, page, searchText, locationPresentation, southWest, northEast;

+ (LocationViewModel *)instance {
    static LocationViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];

            _instance.maximumDistance = (int) [HalalGuideSettings instance].distanceFilter;
            _instance.showPork = [HalalGuideSettings instance].porkFilter;
            _instance.showAlcohol = [HalalGuideSettings instance].alcoholFilter;
            _instance.showNonHalal = [HalalGuideSettings instance].halalFilter;

            _instance.categories = [HalalGuideSettings instance].categoriesFilter;
            _instance.shopCategories = [HalalGuideSettings instance].shopCategoriesFilter;
            _instance.locations = [NSMutableArray new];

            _instance.page = 0;

        }
    }

    return _instance;
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
            return or;
        }

        if ([BaseViewModel currentLocation]) {
            [query whereKey:@"point" nearGeoPoint:[PFGeoPoint geoPointWithLocation:[BaseViewModel currentLocation]] withinKilometers:self.maximumDistance < 20 ? self.maximumDistance : 20000];
        }

        //Paging controls
        query.limit = 20;
        query.skip = self.page * 20;
    } else if (self.locationPresentation == LocationPresentationMap) {
        [query whereKey:@"point" withinGeoBoxFromSouthwest:self.southWest toNortheast:self.northEast];
    }


    return query;
}

- (void)reset {
    self.locations = [NSMutableArray new];
    self.page = 0;
    self.locationPresentation = LocationPresentationList;
}

- (void)locationChanged:(NSNotification *)notification {

    [super locationChanged:notification];

    self.locations = [[NSMutableArray alloc] initWithArray:[self calculateDistances:self.locations sortByDistance:true]];

    if ([self.delegate respondsToSelector:@selector(refreshTable)]) {
        [self.delegate refreshTable];
    }
}

- (void)refreshLocations:(BOOL)firstLoad {

    if (firstLoad) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeGradient];
    }

    [[LocationService instance] locationsByQuery:self.query onCompletion:^(NSArray *objects, NSError *error) {

        [SVProgressHUD dismiss];

        if (error) {

            [[ErrorReporting instance] reportError:error];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.localizedDescription]];

        } else {

            if (self.page != 0) {
                [self.locations addObjectsFromArray:objects];
                self.locations = [[NSMutableArray alloc] initWithArray:[self calculateDistances:self.locations sortByDistance:false]];
            } else {
                self.locations = [[NSMutableArray alloc] initWithArray:[self calculateDistances:objects sortByDistance:true]];
            }
        }

        if (self.locationPresentation == LocationPresentationList) {
            if ([self.delegate respondsToSelector:@selector(reloadTable)]) {
                [self.delegate reloadTable];
            }
        } else if (self.locationPresentation == LocationPresentationMap) {
            if ([self.delegate respondsToSelector:@selector(reloadAnnotations)]) {
                [self.delegate reloadAnnotations];
            }
        }


    }];
}

- (void)setLocationType:(LocationType)locationType1 {
    self.searchText = @"";
    locationType = locationType1;
}


- (NSUInteger)numberOfLocations {
    return [self.locations count];
}

- (Location *)locationForRow:(NSUInteger)row {
    if (self.locations == nil || [self.locations count] <= row) {
        return nil;
    }

    return [self.locations objectAtIndex:row];
}
@end
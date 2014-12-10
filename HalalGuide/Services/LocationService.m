//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "LocationService.h"
#import "HalalGuideSettings.h"


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
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)lastTenLocations:(PFArrayResultBlock)completion {
    #warning set creationStatus == 1 in production
    PFQuery *query = [PFQuery queryWithClassName:kLocationTableName];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"creationStatus" equalTo:@(0)];
    [query orderByDescending:@"updatedAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)createDummyData {

    @throw @"Must be converted to dictionary objects";
/*
    Location *l1 = [Location create];
    l1.name = @"Curry Take Away";
    l1.addressRoad = @"Borups Alle";
    l1.addressRoadNumber = @"29";
    l1.addressPostalCode = @"2200";
    l1.addressCity = @"København N";
    l1.latitude = @55.6903656;
    l1.longitude = @12.5428984;
    l1.telephone = @"00000000";
    l1.homePage = @"www.currytakeaway.dk";
    l1.locationType = @(LocationTypeDining);
    l1.categoriesArray = @[@(DiningCategoryIndian), @(DiningCategoryPakistani)];
    l1.nonHalal = @0;
    l1.alcohol = @0;
    l1.pork = @0;
    l1.language = @(LanguageNone);
    l1.creationStatus = @(CreationStatusApproved);
    l1.submitterId = @"TEST";

    [self saveLocation:l1 onCompletion:^(NSString *id, NSError *error) {

    }];

    return;

    Location *l2 = [Location create];
    l2.name = @"WAKF";
    l2.addressRoad = @"Dortheavej";
    l2.addressRoadNumber = @"45 - 47";
    l2.addressPostalCode = @"2400";
    l2.addressCity = @"København N";
    l2.latitude = @55.7083465;
    l2.longitude = @12.5254281;
    l2.telephone = @"00000000";
    l2.homePage = @"www.wakf.com";
    l2.locationType = @(LocationTypeMosque);
    l2.categoriesArray = nil;
    l2.nonHalal = @0;
    l2.alcohol = @0;
    l2.pork = @0;
    l2.language = @(LanguageArabic);
    l2.creationStatus = @(CreationStatusApproved);
    l2.submitterId = @"TEST";

    [self saveLocation:l2 onCompletion:^(NSString *id,NSError *error) {
    }];

    Location *l3 = [Location create];
    l3.name = @"Dansk Islamisk Råd";
    l3.addressRoad = @"Vingelodden";
    l3.addressRoadNumber = @"1";
    l3.addressPostalCode = @"2200";
    l3.addressCity = @"København N";
    l3.latitude = @55.7084999;
    l3.longitude = @12.549223;
    l3.telephone = @"00000000";
    l3.homePage = @"www.disr.info";
    l3.locationType = @(LocationTypeMosque);
    l3.categoriesArray = nil;
    l3.nonHalal = @0;
    l3.alcohol = @0;
    l3.pork = @0;
    l3.language = @(LanguageDanish);
    l3.creationStatus = @(CreationStatusApproved);
    l3.submitterId = @"TEST";

    [self saveLocation:l3 onCompletion:^(NSString *id,NSError *error) {
    }];

    Location *l4 = [Location create];
    l4.name = @"Istanbul Bazar";
    l4.addressRoad = @"Frederiksborgvej";
    l4.addressRoadNumber = @"15";
    l4.addressPostalCode = @"2400";
    l4.addressCity = @"København NV";
    l4.latitude = @55.702917;
    l4.longitude = @12.532926;
    l4.telephone = @"00000000";
    l4.homePage = nil;
    l4.locationType = @(LocationTypeShop);
    l4.categoriesArray = nil;
    l4.nonHalal = @0;
    l4.alcohol = @0;
    l4.pork = @0;
    l4.language = @(LanguageNone);
    l4.creationStatus = @(CreationStatusApproved);
    l4.submitterId = @"TEST";

    [self saveLocation:l4 onCompletion:^(NSString *id,NSError *error) {
    }];

    Location *l5 = [Location create];
    l5.name = @"Marco's Pizzabar";
    l5.addressRoad = @"Hulgårdsvej";
    l5.addressRoadNumber = @"7";
    l5.addressPostalCode = @"2400";
    l5.addressCity = @"København NV";
    l5.latitude = @55.69151012;
    l5.longitude = @12.5106906;
    l5.telephone = @"00000000";
    l5.homePage = nil;
    l5.locationType = @(LocationTypeDining);
    l5.categoriesArray = @[@(DiningCategoryPizza)];
    l5.nonHalal = @1;
    l5.alcohol = @1;
    l5.pork = @1;
    l5.language = @(LanguageNone);
    l5.creationStatus = @(CreationStatusApproved);
    l5.submitterId = @"TEST";

    [self saveLocation:l5 onCompletion:^(NSString *id,NSError *error) {
    }];

    Location *l6 = [Location create];
    l6.name = @"J & B Supermarked";
    l6.addressRoad = @"Frederikssundsvej";
    l6.addressRoadNumber = @"11";
    l6.addressPostalCode = @"2400";
    l6.addressCity = @"København NV";
    l6.latitude = @55.701255;
    l6.longitude = @12.535705;
    l6.telephone = @"00000000";
    l6.homePage = nil;
    l6.locationType = @(LocationTypeShop);
    l6.categoriesArray = nil;
    l6.nonHalal = @0;
    l6.alcohol = @0;
    l6.pork = @0;
    l6.language = @(LanguageNone);
    l6.creationStatus = @(CreationStatusApproved);
    l6.submitterId = @"TEST";

    [self saveLocation:l6 onCompletion:^(NSString *id,NSError *error) {
    }];

    Location *l7 = [Location create];
    l7.name = @"Sultans Cafe";
    l7.addressRoad = @"Borups Alle";
    l7.addressRoadNumber = @"112";
    l7.addressPostalCode = @"2000";
    l7.addressCity = @"Frederiksberg";
    l7.latitude = @55.6920414;
    l7.longitude = @12.5352193;
    l7.telephone = @"00000000";
    l7.homePage = nil;
    l7.locationType = @(LocationTypeDining);
    l7.categoriesArray = @[@(DiningCategoryCafe)];
    l7.nonHalal = @1;
    l7.alcohol = @1;
    l7.pork = @1;
    l7.language = @(LanguageNone);
    l7.creationStatus = @(CreationStatusApproved);
    l7.submitterId = @"TEST";

    [self saveLocation:l7 onCompletion:^(NSString *id,NSError *error) {
    }];
 */
}


@end
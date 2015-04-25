//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ReactiveCocoa/RACSubscriber.h>
#import "HGCreateLocationViewModel.h"
#import "HGAddressService.h"
#import "HGLocationService.h"
#import "HGPictureService.h"
#import "HGGeoLocationService.h"

@interface HGCreateLocationViewModel ()
@property(nonatomic) LocationType locationType;
@property(nonatomic, strong) NSDictionary *streetDictionary;
@property(nonatomic, strong) HGLocation *createdLocation;

@end

@implementation HGCreateLocationViewModel {

}

@synthesize locationType, streetDictionary, categories, shopCategories, language;
@synthesize name, road, roadNumber, postalCode, city, telephone, website, pork, alcohol, nonHalal, images;

- (instancetype)initWithLocationType:(LocationType)type {
    self = [super init];
    if (self) {
        locationType = type;
        streetDictionary = [NSDictionary new];
        categories = [[NSMutableArray alloc] init];
        shopCategories = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSArray *)streetNameForPrefix:(NSString *)prefix {
    return [[self.streetDictionary allKeys] linq_where:^BOOL(NSString *item) {
        return [item hasPrefix:prefix];
    }];
}

- (NSArray *)streetNumbersForRoad {
    SimpleAddress *address = [self.streetDictionary valueForKey:self.road];
    return address.numbers;
}

- (Postnummer *)postalCodeForRoad {
    SimpleAddress *address = [self.streetDictionary valueForKey:self.road];
    return address.postnummer;
}

- (void)loadAddressesNearPositionOnCompletion:(void (^)(void))completion {
    CLLocation *location = [HGGeoLocationService instance].currentLocation;

    [HGAddressService addressNearPosition:location onCompletion:^(NSArray *addresses) {

        NSMutableDictionary *streetNumbersTemp = [NSMutableDictionary new];
        for (HGAdgangsadresse *key in addresses) {

            SimpleAddress *address = [streetNumbersTemp valueForKey:key.vejstykke.navn];
            if (!address) {
                address = [[SimpleAddress alloc] initWithName:key.vejstykke.navn numbers:[@[key.husnr] mutableCopy] postalCode:key.postnummer];
                [streetNumbersTemp setValue:address forKey:key.vejstykke.navn];
            } else {
                [address.numbers addObject:key.husnr];
            }
        }
        self.streetDictionary = streetNumbersTemp;

        if (completion) {
            completion();
        }
    }];
}

- (void)cityNameForPostalCode:(void (^)(Postnummer *postNummer))completion {
    [HGAddressService cityNameFor:self.postalCode onCompletion:completion];
}

- (void)saveLocation {

    self.error = nil;
    self.progress = 1;

    HGLocation *location = [HGLocation locationWithAddressCity:self.city addressPostalCode:self.postalCode addressRoad:self.road addressRoadNumber:self.roadNumber alcohol:@(self.alcohol.boolValue) creationStatus:@(CreationStatusAwaitingApproval) homePage:self.website language:@(self.language) locationType:@(self.locationType) name:self.name nonHalal:@(self.nonHalal.boolValue) pork:@(self.pork.boolValue) submitterId:[PFUser currentUser].objectId telephone:self.telephone categories:self.typeBaseCategories];

    [[[[[self doesAddressExist] flattenMap:^RACStream *(HGAdgangsadresse *value) {
        location.point = [self pointForAddress:value];
        return [self saveLocation:location];
    }] then:^RACSignal * {
        return self.images ? [self saveImagesForLocation:location] : [RACSignal empty];
    }] finally:^{
        self.createdLocation = location;
        self.progress= 100;
    }] subscribeError:^(NSError *error) {
        self.error = error;
        [location deleteEventually];
    }];
}

- (NSArray *)typeBaseCategories {
    switch (self.locationType) {
        case LocationTypeMosque: {
            return nil;
        }
        case LocationTypeDining: {
            return self.categories;
        }
        case LocationTypeShop: {
            return self.shopCategories;
        }
        default: {
            return nil;
        }
    }
}

- (PFGeoPoint *)pointForAddress:(HGAdgangsadresse *)address {
    if (address) {
        return [PFGeoPoint geoPointWithLatitude:[address.latitude doubleValue] longitude:[address.longitude doubleValue]];
    } else {
        return nil;
    }
}

- (RACSignal *)doesAddressExist {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [HGAddressService doesAddressExist:self.road roadNumber:self.roadNumber postalCode:self.postalCode onCompletion:^(HGAdgangsadresse *address) {
            [subscriber sendNext:address];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)saveLocation:(HGLocation *)location {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[HGLocationService instance] saveLocation:location onCompletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [subscriber sendNext:@(succeeded)];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)saveImagesForLocation:(HGLocation *)location {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[HGPictureService instance] saveMultiplePictures:self.images forLocation:location completion:^(BOOL completed, NSError *error, NSNumber *progress) {
            if (progress) {
                self.progress = progress.intValue;
                [subscriber sendNext:progress];
            }
            if (completed) {
                [subscriber sendCompleted];
            }
            if (error) {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}


@end